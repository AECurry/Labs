//
//  SecondView.swift
//  LifeCycle Lab
//
//  Created by AnnElaine on 10/21/25.
//

import SwiftUI

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var events: [String]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Second View")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("This is a separate view to demonstrate navigation lifecycle events.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Go Back to Main") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Second View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            events.append("SecondView appeared - \(Date().formatted(date: .omitted, time: .standard))")
        }
        .onDisappear {
            events.append("SecondView disappeared - \(Date().formatted(date: .omitted, time: .standard))")
        }
    }
}
