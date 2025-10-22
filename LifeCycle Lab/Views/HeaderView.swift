//
//  HeaderView.swift
//  LifeCycleLab
//
//  Created by AnnElaine on 10/21/25.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            Text("Lifecycle Lab")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Observe SwiftUI View Lifecycle Events")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
