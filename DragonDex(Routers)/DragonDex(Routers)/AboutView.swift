//
//  AboutView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

struct AboutView: View {
    @Environment(MainRouter.self) private var router
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "dragon")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
            
            Text("DragonDex Companion")
                .font(.largeTitle)
                .bold()
            
            Text("Version 1.0.0")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("Your digital encyclopedia for legendary dragons and their riders.")
                .multilineTextAlignment(.center)
                .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(icon: "flame.fill", text: "7 Elemental Dragon Types")
                FeatureRow(icon: "bolt.fill", text: "Power Analysis")
                FeatureRow(icon: "person.2.fill", text: "Rider Profiles")
                FeatureRow(icon: "paintpalette.fill", text: "Custom Themes")
            }
            .padding()
            
            Spacer()
            
            Button("Done") {
                router.dismissSheet()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.orange)
                .frame(width: 30)
            
            Text(text)
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
            .environment(MainRouter())
    }
}

