//
//  Extensions.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI


extension View {
    func errorAlert(errorMessage: Binding<String?>) -> some View {
        self.alert("Error", isPresented: .constant(errorMessage.wrappedValue != nil)) {
            Button("OK") {
                errorMessage.wrappedValue = nil
            }
        } message: {
            Text(errorMessage.wrappedValue ?? "")
        }
    }
}


extension Color {
    static let primaryBlue = Color.blue
    static let primaryPurple = Color.purple
}


extension LinearGradient {
    static let primaryGradient = LinearGradient(
        colors: [.blue, .purple],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}


extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

