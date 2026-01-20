//
//  BottomNavigationBar.swift
//  TripLogger2App
//
//  Created by Your Name on 1/15/26.
//

import SwiftUI

struct BottomNavigationBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 0) {
                // Home Tab
                Button(action: {
                    selectedTab = 0
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .font(.system(size: 24, weight: .medium))
                        Text("Home")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(selectedTab == 0 ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                }
                
                // Map Tab
                Button(action: {
                    selectedTab = 1
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == 1 ? "map.fill" : "map")
                            .font(.system(size: 24, weight: .medium))
                        Text("Map")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(selectedTab == 1 ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                }
                
                // Journal Tab
                Button(action: {
                    selectedTab = 2
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == 2 ? "book.fill" : "book")
                            .font(.system(size: 24, weight: .medium))
                        Text("Journal")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(selectedTab == 2 ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 34)
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.bottom) // CHANGED: Extends all the way to bottom
    }
}
