//
//  UsernameFieldView.swift
//  AdvancedTechniquesLab
//
//  Created by AnnElaine on 1/5/26.
//

import SwiftUI

struct UsernameFieldView: View {
    @Binding var username: String
    
    var body: some View {
        TextField("Username", text: $username)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .inputFieldStyle()
    }
}
