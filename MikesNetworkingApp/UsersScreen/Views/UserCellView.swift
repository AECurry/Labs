//
//  UserCellView.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI

struct UserCellView: View {
    // 1. Remove @ObservedObject. Just use standard let/var!
    var viewModel: UserCellViewModel
    let settings: Settings

    // ... The rest of your UserCellView body and logic remains exactly the same ...
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: Header row — photo + name
            HStack(spacing: 14) {
                profileImage
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)

                Text(viewModel.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()
            }

            // MARK: Info rows for selected fields
            let rows = viewModel.infoRows(for: settings)
            if !rows.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(rows, id: \.1) { icon, label, value in
                        InfoRowView(icon: icon, label: label, value: value)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 70) // aligns under the name text
            }
        }
        .padding(.vertical, 10)
        .task { await viewModel.loadImage() }
    }

    // MARK: - Profile Image
    @ViewBuilder
    private var profileImage: some View {
        if let data = viewModel.imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            ZStack {
                Color.gray.opacity(0.2)
                if viewModel.isLoadingImage {
                    ProgressView()
                } else {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

// MARK: - Small reusable row
private struct InfoRowView: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(.blue)
                .frame(width: 14)

            Text(value)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

