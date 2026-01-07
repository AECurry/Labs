//
//  NewGeometryView.swift
//  FunWithGeometry
//
//  Created by AnnElaine on 1/6/26.
//

import SwiftUI

struct NewGeometryView: View {
    @Environment(\.horizontalSizeClass) var
    horizontalSizeClass
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var framewidthDivision: CGFloat {
        if verticalSizeClass == .compact {
            return 2
        } else {
            return 3
        }
    }
    
    
    var body: some View {
        VStack {
            if horizontalSizeClass == .compact {
                Text("Horixontal: Compact")
            } else {
                Text("Horizontal: Regular ")
            }
            
            if verticalSizeClass == .compact {
                Text("Vertical: Compact")
            } else {
                Text("Vertical: Regular")
            }
            
            GeometryReader { geometry in Rectangle()
                    .fill(.cyan)
                    .frame(width: geometry.size.width / framewidthDivision)
            }
        }
        
    }
}

#Preview {
    NewGeometryView()
}
