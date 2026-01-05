//
//  PasswordFieldView.swift
//  AdvancedTechniquesLab
//
//  Created by AnnElaine on 1/5/26.
//

import SwiftUI

struct PasswordFieldView: View {
    @Binding var password: String
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        HStack {
            if isPasswordVisible {
                TextField("Password", text: $password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                SecureField("Password", text: $password)
            }
            
            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
            }
        }
        .inputFieldStyle()
    }
}
