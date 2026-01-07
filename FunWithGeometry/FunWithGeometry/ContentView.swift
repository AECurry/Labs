//
//  ContentView.swift
//  FunWithGeometry
//
//  Created by AnnElaine on 1/6/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                Rectangle()
                    .fill(.cyan)
                    .containerRelativeFrame(.horizontal) {
                        width, height in
                        
                        width / 2
                    }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
