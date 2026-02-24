//
//  SettingsView.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Binding var navigationPath: NavigationPath
    
    let options: [(icon: String, title: String, keyPath: WritableKeyPath<Settings, Bool>)] = [
        ("person.fill", "Gender", \.showGender),
        ("location.fill", "Location", \.showLocation),
        ("envelope.fill", "Email", \.showEmail),
        ("person.circle.fill", "Login", \.showLogin),
        ("calendar.badge.plus", "Registered", \.showRegistered),
        ("cake.fill", "Birthday", \.showDob),
        ("phone.fill", "Phone", \.showPhone),
        ("iphone", "Cell", \.showCell),
        ("person.text.rectangle.fill", "ID", \.showID),
        ("flag.fill", "Nationality", \.showNationality)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                userCountSection
                optionsSection
                fetchButtonSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 60))
                .foregroundStyle(.blue, .purple)
            
            Text("Random User Generator")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }
    
    private var userCountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Number of Users", systemImage: "person.3.fill")
                .font(.headline)
                .foregroundColor(.blue)
            
            HStack {
                Slider(
                    value: Binding(
                        get: { Double(viewModel.settings.numberOfUsers) },
                        set: { viewModel.settings.numberOfUsers = Int($0) }
                    ),
                    in: 1...50,
                    step: 1
                )
                .tint(.blue)
                
                Text("\(viewModel.settings.numberOfUsers)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .frame(width: 40)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
    
    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Information to Display", systemImage: "checklist")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button("All") {
                        withAnimation { viewModel.toggleAllOptions(true) }
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    
                    Button("None") {
                        withAnimation { viewModel.toggleAllOptions(false) }
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(options, id: \.title) { option in
                    HStack {
                        Image(systemName: option.icon)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        
                        Text(option.title)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { viewModel.settings[keyPath: option.keyPath] },
                            set: { viewModel.settings[keyPath: option.keyPath] = $0 }
                        ))
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .scaleEffect(0.8)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
    
    private var fetchButtonSection: some View {
        Button {
            Task {
                await viewModel.fetchUsers()
                if !viewModel.users.isEmpty {
                    navigationPath.append(viewModel.users)
                }
            }
        } label: {
            HStack {
                Image(systemName: "arrow.down.doc.fill")
                Text("Fetch Users")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: viewModel.isLoading ? [.gray] : [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(viewModel.isLoading)
        .padding(.top, 12)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
