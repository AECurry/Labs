//
//  DatePickerStepView.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct DatePickerStepView: View {
    @Environment(CardCreationCoordinator.self) private var coordinator
    
    private var thirtyDaysFromNow: Date {
        Calendar.current.date(byAdding: .day, value: 30, to: Date())!
    }
    
    var body: some View {
        @Bindable var coordinator = coordinator
        
        VStack(spacing: 44) {
            // Progress dots at top
            ProgressDotsView(
                currentStep: coordinator.currentStep.rawValue,
                totalSteps: CreationStep.allCases.count
            )
            .padding(.top, 10)
            
            // Instructions
            Text("When is the party?")
                .font(.title2)
                .fontWeight(.medium)
            
            // Date picker - NOW using $coordinator.card.date
            VStack(alignment: .leading, spacing: 10) {
                Text("Select Date & Time")
                    .font(.headline)
                
                DatePicker(
                    "",
                    selection: $coordinator.card.date,
                    in: Date()...thirtyDaysFromNow,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            // Selected date display
            VStack(spacing: 8) {
                Text("Selected Date & Time")
                    .font(.headline)
                
                Text(coordinator.card.date.formatted(date: .long, time: .shortened))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                // Countdown
                if coordinator.card.date > Date() {
                    let daysUntil = Calendar.current.dateComponents([.day], from: Date(), to: coordinator.card.date).day ?? 0
                    Text("\(daysUntil) days from now")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            // Navigation buttons at bottom
            StepNavigationView()
        }
        .padding()
        .navigationTitle("Select Date")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let coordinator = CardCreationCoordinator()
    coordinator.card.date = Date().addingTimeInterval(86400 * 7)
    
    return DatePickerStepView()
        .environment(coordinator)
}
