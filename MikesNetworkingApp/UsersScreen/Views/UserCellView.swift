//
//  UserCellView.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI

struct UserCellView: View {
    @ObservedObject var viewModel: UserCellViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Image
            Group {
                if let imageData = viewModel.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.gray.opacity(0.3)
                        .overlay {
                            if viewModel.isLoadingImage {
                                ProgressView()
                            } else {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.displayName)
                    .font(.headline)
                
                // Additional fields would go here based on settings
                // This would be populated from the viewModel
            }
        }
        .padding(.vertical, 4)
    }
}
