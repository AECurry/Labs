//
//  HealthKitManager.swift
//  MASUKI
//
//  Created by AnnElaine on 1/9/26.
//

import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    private let distanceType = HKQuantityType(.distanceWalkingRunning)
    private let caloriesType = HKQuantityType(.activeEnergyBurned)
    private let workoutType = HKObjectType.workoutType()
    
    private init() {}
    
    // MARK: - Authorization
    func requestAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        
        let readTypes: Set<HKObjectType> = [
            distanceType,
            HKQuantityType(.stepCount),
            caloriesType,
            workoutType
        ]
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: readTypes)
            return true
        } catch {
            print("HealthKit authorization error: \(error)")
            return false
        }
    }
    
    // MARK: - Distance Queries
    func getAllTimeDistance() async -> Double {
        await fetchDistance(from: .distantPast, to: .now)
    }
    
    func getTodayDistance() async -> Double {
        let startOfDay = Calendar.current.startOfDay(for: .now)
        return await fetchDistance(from: startOfDay, to: .now)
    }
    
    func getWeeklyDistances() async -> [DailyDistance] {
        var distances: [DailyDistance] = []
        
        for dayOffset in 0..<7 {
            let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: .now)!
            let startOfDay = Calendar.current.startOfDay(for: date)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let distance = await fetchDistance(from: startOfDay, to: endOfDay)
            distances.append(DailyDistance(date: date, distance: distance))
        }
        
        return distances.sorted { $0.date < $1.date }
    }
    
    // MARK: - Today's Workout Sessions
    func getTodayWorkouts() async -> [TodaySession] {
        let startOfDay = Calendar.current.startOfDay(for: .now)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        
        // Filter for walking workouts
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .walking)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, workoutPredicate])
        
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: workoutType,
                predicate: compoundPredicate,
                limit: 3, // Only return up to 3 sessions
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, error in
                guard let workouts = samples as? [HKWorkout], error == nil else {
                    continuation.resume(returning: [])
                    return
                }
                
                // Process workouts asynchronously to fetch calories using new API
                Task {
                    let sessions = await withTaskGroup(of: TodaySession?.self) { group in
                        for workout in workouts {
                            group.addTask {
                                await self.createTodaySession(from: workout)
                            }
                        }
                        
                        var sessions: [TodaySession] = []
                        for await session in group {
                            if let session = session {
                                sessions.append(session)
                            }
                        }
                        return sessions
                    }
                    
                    continuation.resume(returning: sessions)
                }
            }
            
            healthStore.execute(query)
        }
    }
    
    // MARK: - Helper to create TodaySession with new HealthKit API
    private func createTodaySession(from workout: HKWorkout) async -> TodaySession? {
        let startTime = workout.startDate
        let endTime = workout.endDate
        let duration = workout.duration
        
        // Get distance (still available on workout object)
        let distance = workout.totalDistance?.doubleValue(for: .mile()) ?? 0
        
        // Get calories using the new statisticsForType API
        let calories = await fetchCaloriesForWorkout(workout)
        
        return TodaySession(
            id: UUID(),
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            distance: distance,
            calories: calories
        )
    }
    
    // MARK: - Fetch calories for a specific workout using new API
    private func fetchCaloriesForWorkout(_ workout: HKWorkout) async -> Double {
        let startDate = workout.startDate
        let endDate = workout.endDate
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: caloriesType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, statistics, _ in
                let calories = statistics?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                continuation.resume(returning: calories)
            }
            healthStore.execute(query)
        }
    }
    
    // MARK: - Today's Active Time
    func getTodayActiveTime() async -> TimeInterval {
        let startOfDay = Calendar.current.startOfDay(for: .now)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .walking)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, workoutPredicate])
        
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: workoutType,
                predicate: compoundPredicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, error in
                guard let workouts = samples as? [HKWorkout], error == nil else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let totalDuration = workouts.reduce(0) { $0 + $1.duration }
                continuation.resume(returning: totalDuration)
            }
            
            healthStore.execute(query)
        }
    }
    
    // MARK: - Today's Calories
    func getTodayCalories() async -> Double {
        let startOfDay = Calendar.current.startOfDay(for: .now)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return await fetchCalories(from: startOfDay, to: endOfDay)
    }
    
    // MARK: - Private Helpers
    private func fetchDistance(from start: Date, to end: Date) async -> Double {
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: distanceType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                let miles = result?.sumQuantity()?.doubleValue(for: .mile()) ?? 0
                continuation.resume(returning: miles)
            }
            healthStore.execute(query)
        }
    }
    
    private func fetchCalories(from start: Date, to end: Date) async -> Double {
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: caloriesType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                let calories = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                continuation.resume(returning: calories)
            }
            healthStore.execute(query)
        }
    }
    // MARK: - Historical Queries (ADD TO EXISTING FILE)

    /// Fetches workouts for a specific date range
    func getWorkouts(from startDate: Date, to endDate: Date) async -> [TodaySession] {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .walking)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, workoutPredicate])
        
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: workoutType,
                predicate: compoundPredicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, error in
                guard let workouts = samples as? [HKWorkout], error == nil else {
                    continuation.resume(returning: [])
                    return
                }
                
                // Process workouts asynchronously to fetch calories for each one
                Task {
                    let sessions = await withTaskGroup(of: TodaySession?.self) { group in
                        for workout in workouts {
                            group.addTask {
                                await self.createTodaySession(from: workout)
                            }
                        }
                        
                        var sessions: [TodaySession] = []
                        for await session in group {
                            if let session = session {
                                sessions.append(session)
                            }
                        }
                        return sessions.sorted { $0.startTime < $1.startTime }
                    }
                    
                    continuation.resume(returning: sessions)
                }
            }
            
            healthStore.execute(query)
        }
    }
}
