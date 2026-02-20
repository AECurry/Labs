//
//  DurationDropdown.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

struct DurationDropdown: View {
    @Binding var selectedDuration: DurationOption
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Duration")
                .font(.custom("Inter-SemiBold", size: 18))
                .foregroundColor(MasukiColors.adaptiveText)
            
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(selectedDuration.displayName)
                        .font(.custom("Inter-Medium", size: 16))
                        .foregroundColor(MasukiColors.adaptiveText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundColor(MasukiColors.mediumJungle)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(MasukiColors.mediumJungle, lineWidth: 2)
                )
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(DurationOption.allCases) { option in
                        DurationOptionRow(
                            option: option,
                            isSelected: selectedDuration == option
                        ) {
                            selectedDuration = option
                            isExpanded = false
                        }
                        
                        if option != DurationOption.allCases.last {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(MasukiColors.adaptiveBackground)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                )
            }
        }
    }
}

struct DurationOptionRow: View {
    let option: DurationOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(option.displayName)
                        .font(.custom("Inter-Medium", size: 16))
                        .foregroundColor(isSelected ? MasukiColors.mediumJungle : MasukiColors.adaptiveText)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(MasukiColors.mediumJungle)
                    }
                }
                
                Text(option.description)
                    .font(.custom("Inter-Regular", size: 12))
                    .foregroundColor(MasukiColors.coffeeBean)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(isSelected ? MasukiColors.mediumJungle.opacity(0.1) : Color.clear)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DurationDropdown(selectedDuration: .constant(.twentyOne))
        .padding()
        .background(MasukiColors.adaptiveBackground)
}

