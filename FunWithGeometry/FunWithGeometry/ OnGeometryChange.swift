//
//   OnGeometryChange.swift
//  FunWithGeometry
//
//  Created by AnnElaine on 1/6/26.
//

import SwiftUI

struct OnGeometryChangeView: View {
    @State private var text = ""
    @State private var textSize: CGSize = .zero
    
    var body: some View {
        VStack {
            Text(text)
                .onGeometryChange(for: CGSize.self) {
                    geometry in
                    
                    geometry.size
                } action: { newValue in
                    textSize=newValue
                }
            
            Rectangle()
                .fill(.black)
                .frame(width: textSize.width, height: 8)
            
            TextField("Type Here", text: $text)
        }
    }
}
