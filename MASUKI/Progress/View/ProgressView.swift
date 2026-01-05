//
//  ProgressView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

import SwiftUI

struct ProgressView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()
            
            VStack {
                Text("Progress")
                    .font(.custom("Spinnaker-Regular", size: 32))
                    .foregroundColor(MasukiColors.adaptiveText)
                    .padding(.top, 40)
                
                Spacer()
                
                // Your progress content here
                VStack(spacing: 20) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 60))
                        .foregroundColor(MasukiColors.mediumJungle)
                    
                    Text("Track your progress")
                        .font(.custom("Inter-Regular", size: 18))
                        .foregroundColor(MasukiColors.adaptiveText)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ProgressView()
}
