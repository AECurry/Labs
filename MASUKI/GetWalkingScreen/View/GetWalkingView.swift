//
//  GetWalkingView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/29/25.
//

import SwiftUI

struct GetWalkingViewSimple: View {
    let onStartWalking: () -> Void

    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderView()
                TitleView()
                ImageAreaView()
                
                StartWalkingButton {
                    onStartWalking()
                }

                Spacer()
            }
        }
    }
}

#Preview {
    GetWalkingViewSimple(onStartWalking: { print("Start Walking") })
}

