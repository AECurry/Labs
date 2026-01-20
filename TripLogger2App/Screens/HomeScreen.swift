//
//  HomeScreen.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/12/26.
//

import SwiftUI

struct HomeScreen: View {
    @State private var showingSettings = false
    @State private var showingNewTrip = false
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button {
                    showingSettings.toggle()
                } label: {
                    Image(systemName: "gear")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(12)
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 10)
            
            VStack(spacing: 0) {
                Spacer(minLength: 16)
                
                Image(systemName: "airplane.departure")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)
                    .padding(.bottom, 24)
                
                VStack(spacing: 8) {
                    Text("Welcome to")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Trip Logger")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Your travel journal awaits")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 160)
                
                Button {
                    showingNewTrip = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create New Trip")
                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(18)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
                
                Spacer(minLength: 20)
            }
            .frame(maxHeight: .infinity)
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showingSettings) {
            SimpleSettingsView()
        }
        .sheet(isPresented: $showingNewTrip) {
            NewTripScreen(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    HomeScreen(selectedTab: .constant(0))
}
