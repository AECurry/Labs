//
//  ContactInfoSection.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI

struct ContactInfoSection: View {
    @Binding var email: String
    @Binding var phone: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Contact Information", subtitle: "Optional")
            
            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.fnGray2)
                    .foregroundColor(.fnWhite)
                    .cornerRadius(8)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                
                TextField("Phone Number", text: $phone)
                    .padding()
                    .background(Color.fnGray2)
                    .foregroundColor(.fnWhite)
                    .cornerRadius(8)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
            }
        }
        .sectionStyle()
    }
}

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.0, blue: 0.15)
            .ignoresSafeArea()
        
        ContactInfoSection(
            email: .constant(""),
            phone: .constant("")
        )
        .padding()
    }
}
