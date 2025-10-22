//
//  EventsLogView.swift
//  LifeCycleLab
//
//  Created by AnnElaine on 10/21/25.
//

import SwiftUI

struct EventsLogView: View {
    let events: [String]
    let clearAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Lifecycle Events")
                    .font(.headline)
                
                Spacer()
                
                Button("Clear Events") {
                    clearAction()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 5) {
                    ForEach(events.reversed(), id: \.self) { event in
                        Text("\(event)")
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }
            .frame(height: 200)
            .padding()
            .background(Color.black.opacity(0.05))
            .cornerRadius(10)
        }
        .padding()
    }
}
