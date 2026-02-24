//
//  WalkSessionConfirmationAlert.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//
//  COMPONENT — reusable alert modifier.
//  Handles exit and stop confirmation dialogs for the walk session screen.
//

import SwiftUI

// MARK: - Alert Type
enum SessionAlertType {
    case exitToTab(Int)
    case stopSession

    var title: String {
        switch self {
        case .exitToTab:   return "Leave Walking Session?"
        case .stopSession: return "Stop Walking Session?"
        }
    }

    var message: String {
        switch self {
        case .exitToTab:
            return "You're currently in a walking session. Leaving will stop your session. Are you sure?"
        case .stopSession:
            return "Are you sure you want to stop this session? Your progress will not be saved."
        }
    }

    var confirmButtonText: String {
        switch self {
        case .exitToTab:   return "Leave Session"
        case .stopSession: return "Stop Session"
        }
    }
}

// MARK: - View Modifier
struct SessionConfirmationAlert: ViewModifier {
    @Binding var alertType: SessionAlertType?
    let onConfirm: (SessionAlertType) -> Void

    func body(content: Content) -> some View {
        content
            .alert(
                alertType?.title ?? "",
                isPresented: Binding(
                    get: { alertType != nil },
                    set: { if !$0 { alertType = nil } }
                )
            ) {
                Button("Cancel", role: .cancel) { alertType = nil }
                Button(alertType?.confirmButtonText ?? "Confirm", role: .destructive) {
                    if let type = alertType { onConfirm(type) }
                    alertType = nil
                }
            } message: {
                Text(alertType?.message ?? "")
            }
    }
}

// MARK: - View Extension
extension View {
    func sessionConfirmationAlert(
        alertType: Binding<SessionAlertType?>,
        onConfirm: @escaping (SessionAlertType) -> Void
    ) -> some View {
        self.modifier(SessionConfirmationAlert(alertType: alertType, onConfirm: onConfirm))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var alertType: SessionAlertType? = nil
        var body: some View {
            VStack(spacing: 20) {
                Button("Show Exit Alert") { alertType = .exitToTab(1) }
                Button("Show Stop Alert") { alertType = .stopSession }
            }
            .padding()
            .sessionConfirmationAlert(alertType: $alertType) { type in
                print("Confirmed: \(type)")
            }
        }
    }
    return PreviewWrapper()
}
