//
//  SelectionControlsView.swift
//  ParkersRandomSelectorApp
//
//  Created by AnnElaine on 2/23/26.
//

// DUMB CHILD VIEW - Selection stepper and GO button
import SwiftUI

struct SelectionControlsView: View {
    @Binding var selectionCount: Int // Two-way binding to parent
    let userCount: Int
    let onGo: () -> Void
    let isDisabled: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Select:")
                Stepper("\(selectionCount) person(s) (max 8)",
                       value: $selectionCount,
                       in: 1...max(1, userCount))
            }
            .padding(.horizontal, 16)
            
            Button(action: onGo) {
                Text("GO")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isDisabled ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isDisabled)
            .padding(.horizontal, 16)
        }
        .padding(.vertical)
        .padding(.bottom, 8)
    }
}

#Preview {
    SelectionControlsView(
        selectionCount: .constant(3),
        userCount: 8,
        onGo: {},
        isDisabled: false
    )
}
