//
//  ContentView.swift
//  Meet My Family Project
//
//  Created by AnnElaine on 10/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var familyData = FamilyData()
    @State private var selectedMember: FamilyMember?
    @State private var showAddMemberSheet = false
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 40) {
                        // Family Header
                        VStack(spacing: 15) {
                            Text("Meet My Family")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color("rlNavy"))
                            
                            Text("\(familyData.familyMembers.count) family members")
                                .font(.subheadline)
                                .foregroundColor(Color("rlNavy").opacity(0.7))
                        }
                        .padding(.top, 60)
                        .padding(.horizontal, 20)
                        
                        // Family Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 40) { // Change from 24 to 40 (or higher)
                            ForEach(familyData.familyMembers) { member in
                                FamilyMemberCard(member: member) {
                                    selectedMember = member
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .id(refreshID)
                        
                        Spacer().frame(height: 180)
                    }
                }
                
                // Floating Add Button
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        familyData.addNewFamilyMember()
                    }
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        Text("Add Family Member")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 20)
                    .background(Color("rlNavy"))
                    .cornerRadius(30)
                    .shadow(color: Color("rlNavy").opacity(0.3), radius: 12, x: 0, y: 6)
                }
                .padding(.bottom, 0)
                .padding(.horizontal, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(
                LinearGradient(
                    colors: [Color(.systemGroupedBackground), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
        .sheet(item: $selectedMember) { member in
            FamilyMemberDetailView(
                familyData: familyData, 
                member: member
            )
            .onDisappear {
                refreshID = UUID()
            }
        }
    }
}

#Preview {
    ContentView()
}
