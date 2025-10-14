//
//  FamilyMemberDetailView.swift
//  Meet My Family Project
//
//  Created by AnnElaine on 10/9/25.
//

import SwiftUI

struct FamilyMemberDetailView: View {
    @Bindable var familyData: FamilyData
    @State var member: FamilyMember
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    headerSection
                    
                    // Content Section
                    contentSection
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Back button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                }
                
                // EDIT BUTTON
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditView = true
                    }
                }
            }
            .onAppear {
                print("📱 DETAIL VIEW APPEARED for: \(member.name)")
                print("🔍 Before markAsViewed - hasBeenViewed: \(member.hasBeenViewed)")
                familyData.markAsViewed(member)
                print("🔍 After markAsViewed - hasBeenViewed: \(member.hasBeenViewed)")
                
                // Also check the actual data in familyData
                if let updatedMember = familyData.familyMembers.first(where: { $0.id == member.id }) {
                    print("📊 Data source hasBeenViewed: \(updatedMember.hasBeenViewed)")
                }
            }
            // EDIT SHEET
            .sheet(isPresented: $showingEditView) {
                EditFamilyMemberView(member: $member)
                    .onDisappear {
                        // Save changes back to the family data
                        familyData.updateMember(member)
                    }
            }
        }
    }
    
    // Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                if let assetName = member.assetPhotoName {
                    // Use the asset photo
                    Image(assetName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    // Fallback for new members
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                }
            }
            
            VStack(spacing: 4) {
                Text(member.name.isEmpty ? "Add Name" : member.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(member.relationship.isEmpty ? "Add Relationship" : member.relationship)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 32)
    }
    // Content Section
    private var contentSection: some View {
        VStack(spacing: 16) {
            if hasContentToShow {
                // Age Card
                if member.age > 0 {
                    InfoCard(
                        title: "Age",
                        value: "\(member.age) years old",
                        icon: "calendar",
                        color: .blue
                    )
                }
                
                // Bio Card
                if !member.bio.isEmpty {
                    BioCard(bio: member.bio)
                }
                
                // Hobbies Card
                if !member.hobbies.isEmpty {
                    HobbiesCard(hobbies: member.hobbies)
                }
            } else {
                // Empty State
                emptyStateView
            }
        }
        .padding(.horizontal, 20)
    }
    
    // Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No Information Yet")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("Add details about this family member to make their profile complete")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 40)
    }
    
    // Helper
    private var hasContentToShow: Bool {
        member.age > 0 || !member.bio.isEmpty || !member.hobbies.isEmpty
    }
}

// Supporting Views (keep these the same)
struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

struct BioCard: View {
    let bio: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.quote")
                    .foregroundColor(.green)
                
                Text("About")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Text(bio)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

struct HobbiesCard: View {
    let hobbies: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                
                Text("Hobbies & Interests")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            FlowLayout(spacing: 8) {
                ForEach(hobbies, id: \.self) { hobby in
                    Text(hobby)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.blue.opacity(0.1))
                        )
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// Simple FlowLayout for hobbies
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        
        var lineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for size in sizes {
            if lineWidth + size.width + spacing > proposal.width ?? 0 {
                totalHeight += lineHeight + spacing
                totalWidth = max(totalWidth, lineWidth)
                lineWidth = size.width
                lineHeight = size.height
            } else {
                lineWidth += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
        }
        
        totalHeight += lineHeight
        totalWidth = max(totalWidth, lineWidth)
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var lineX = bounds.minX
        var lineY = bounds.minY
        var lineHeight: CGFloat = 0
        
        for index in subviews.indices {
            if lineX + sizes[index].width > bounds.maxX {
                lineY += lineHeight + spacing
                lineX = bounds.minX
                lineHeight = 0
            }
            
            subviews[index].place(
                at: CGPoint(x: lineX, y: lineY),
                proposal: ProposedViewSize(sizes[index])
            )
            
            lineX += sizes[index].width + spacing
            lineHeight = max(lineHeight, sizes[index].height)
        }
    }
}
