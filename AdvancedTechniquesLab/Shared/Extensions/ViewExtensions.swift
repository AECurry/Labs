//
//  ViewExtensions.swift
//  AdvancedTechniquesLab
//
//  Created by AnnElaine on 1/5/26.
//

import SwiftUI

extension View {
    func inputFieldStyle() -> some View {
        self.modifier(InputFieldModifier())
    }
}
