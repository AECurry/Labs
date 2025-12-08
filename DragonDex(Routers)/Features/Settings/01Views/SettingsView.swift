//
//  SettingsView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(MainRouter.self) private var mainRouter
    @Environment(ThemeBackground.self) private var themeBackground
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Dragon Element") {
                    ForEach(DragonTheme.allCases) { theme in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                themeBackground.setTheme(theme)
                            }
                        } label: {
                            HStack(spacing: 16) {
                                // Theme icon circle
                                ZStack {
                                    Circle()
                                        .fill(theme.themeColor)
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: theme.icon)
                                        .foregroundStyle(.white)
                                        .font(.title3)
                                }
                                
                                // Theme name
                                Text(theme.displayName)
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                                
                                // Checkmark if selected
                                if let currentDragonTheme = themeBackground.currentTheme as? DragonTheme,
                                   currentDragonTheme == theme {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(theme.themeColor)
                                        .font(.title2)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("MythWorks Studio")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        mainRouter.dismissSheet()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(MainRouter())
        .environment(ThemeBackground(theme: DragonTheme.inferno))
}
