//
//  HealthKit.swift
//  MASUKI
//
//  Created by AnnElaine on 1/5/26.
//

import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    private let distanceType = HKQuantityType(.distanceWalkingRunning)
    
    private init() {}
    
    // MARK: - Authorization
    func requestAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        
        let readTypes: Set = [distanceType, HKQuantityType(.stepCount)]
        
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
    
    // MARK: - Private Helper
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
}
