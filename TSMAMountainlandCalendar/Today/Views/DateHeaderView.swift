//
//  DateHeaderView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/8/25.
//

import SwiftUI
import Combine

// MARK: - Date Header View
/// Date header component that displays the current date with live updating and calendar navigation
/// Features a burgundy header with date text and calendar icon button
/// Automatically updates every minute to handle day changes
struct DateHeaderView: View {
    // MARK: - Properties
    let date: Date                   // Initial date to display
    let onCalendarTap: () -> Void    // Callback when calendar icon is tapped
    
    // MARK: - Live Date State
    /// This will automatically refresh when the day changes
    @State private var currentDate = Date()  // Live updating date
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()  // Update every minute
    
    // MARK: - Computed Properties
    /// Formats the current date as "Tuesday 11/13/2024"
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM/dd/yyyy"  // Full weekday + numeric date
        return formatter.string(from: currentDate)
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            // MARK: - Date Text
            /// Displays the formatted date in white text
            Text(formattedDate)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()  // Pushes calendar icon to trailing edge
            
            // MARK: - Calendar Navigation Button
            /// Tappable calendar icon for navigation
            Button(action: onCalendarTap) {
                Image(systemName: "calendar")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)  // Large tap target
            }
        }
        .padding(.horizontal, 16)  // Side padding for content
        .frame(width: 368, height: 64)  // Fixed dimensions matching card width
        .background(MountainlandColors.burgundy1)  // Brand burgundy background
        // MARK: - Header Shape
        /// Rounded top corners with flat bottom for seamless card stacking
        .clipShape(
            .rect(
                topLeadingRadius: 16,    // Rounded top-left corner
                bottomLeadingRadius: 0,  // Flat bottom-left edge
                bottomTrailingRadius: 0, // Flat bottom-right edge
                topTrailingRadius: 16    // Rounded top-right corner
            )
        )
        // MARK: - Live Date Updates
        /// Updates the displayed date every minute to handle day changes
        .onReceive(timer) { _ in
            // Update date every minute to handle day changes
            currentDate = Date()
        }
        .onAppear {
            // Initialize with the provided date when view appears
            currentDate = date
        }
    }
}
