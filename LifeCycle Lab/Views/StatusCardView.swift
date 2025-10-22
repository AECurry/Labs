//
//  StatusCardView.swift
//  LifeCycleLab
//
//  Created by AnnElaine on 10/21/25.
//

import SwiftUI

struct StatusCardView: View {
    let title: String
    let status: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text(status)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
