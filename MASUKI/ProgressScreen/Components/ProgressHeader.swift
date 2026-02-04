//
//  ProgressHeader.swift
//  MASUKI
//
//  Created by AnnElaine on 1/6/26.
//

import SwiftUI

struct ProgressHeader: View {
    @AppStorage("progressHeaderTopPadding") private var topPadding: Double = 0
    @AppStorage("progressHeaderBottomPadding") private var bottomPadding: Double = 8
    @AppStorage("progressHeaderHorizontalPadding") private var horizontalPadding: Double = 48
    
    // Internal sizing
    @AppStorage("progressHeaderIconSize") private var iconSize: Double = 40
    @AppStorage("progressHeaderIconPadding") private var iconPadding: Double = 12
    
    @State private var showCalendar = false
    @State private var calendarViewModel = CalendarViewModel()
    @AppStorage("useMetricSystem") private var useMetric: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: { showCalendar = true }) {
                Image("KanjiMatsukiIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .padding(iconPadding)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
        .sheet(isPresented: $showCalendar) {
            CalendarModalView(
                viewModel: calendarViewModel,
                useMetric: useMetric
            )
        }
    }
}

// MARK: - Calendar Modal View
struct CalendarModalView: View {
    @Bindable var viewModel: CalendarViewModel
    let useMetric: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Calendar grid
                CalendarGridView(viewModel: viewModel)
                    .padding(.top, 16)
                
                Divider()
                    .padding(.vertical, 16)
                
                // Historical data view (shows when date is selected)
                if let data = viewModel.selectedDayData {
                    HistoricalDataView(
                        data: data,
                        useMetric: useMetric
                    )
                } else if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("Select a date to view data")
                        .font(.custom("Inter-Regular", size: 16))
                        .foregroundColor(MasukiColors.coffeeBean)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(MasukiColors.adaptiveBackground)
            .navigationTitle("Walking History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(MasukiColors.mediumJungle)
                }
            }
        }
        .task {
            // Load today's data by default when calendar opens
            await viewModel.selectDate(Date())
        }
    }
}

#Preview {
    ProgressHeader()
}
