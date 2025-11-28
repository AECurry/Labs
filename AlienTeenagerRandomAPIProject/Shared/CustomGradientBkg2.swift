//
//  CustomGradientBkg2.swift
//  AlienTeenagerRandomAPIProject
//

import SwiftUI

struct CustomGradientBkg2: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                .deepNavy,
                .majorelleBlue,
                .deepNavy
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    CustomGradientBkg2()
}
