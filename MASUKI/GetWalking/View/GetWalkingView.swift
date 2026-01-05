//
//  GetWalkingView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

//  Main parent file for the GetWalkingFolder
import SwiftUI

struct GetWalkingView: View {
    @State private var showWalkSetup = false
    
    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView()
                TitleView()
                ImageAreaView()
                StartWalkingButton {
                    showWalkSetup = true
                }
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showWalkSetup) {  // Changed from .sheet to .fullScreenCover
            WalkSetupView()
        }
    }
}

#Preview {
    GetWalkingView()
}
