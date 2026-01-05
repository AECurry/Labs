//
//  TimePickerView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI

struct TimePickerView: View {
    @Binding var isScheduled: Bool
    @Binding var scheduledTime: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Schedule")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            Toggle("Schedule for later", isOn: $isScheduled)
                .foregroundColor(.fnWhite)
                .padding()
                .background(Color.fnGray2)
                .cornerRadius(12)
            
            if isScheduled {
                DatePicker(
                    "Game Time",
                    selection: $scheduledTime,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .foregroundColor(.fnWhite)
                .padding()
                .background(Color.fnGray2)
                .cornerRadius(12)
                
                // Time preview
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.fnGold)
                    
                    Text("Starts in: \(timeUntilStart)")
                        .font(.caption)
                        .foregroundColor(.fnGray1)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.fnBlack.opacity(0.3))
                .cornerRadius(8)
            }
        }
    }
    
    private var timeUntilStart: String {
        let interval = scheduledTime.timeIntervalSinceNow
        if interval < 0 { return "Now" }
        
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.0, blue: 0.15)
            .ignoresSafeArea()
        
        TimePickerView(
            isScheduled: .constant(true),
            scheduledTime: .constant(Date().addingTimeInterval(3600))
        )
        .padding()
    }
}
