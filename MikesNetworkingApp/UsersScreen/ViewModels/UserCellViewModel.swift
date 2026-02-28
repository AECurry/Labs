//
//  UserCellViewModel.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class UserCellViewModel: Identifiable {

    // MARK: - Properties (No more @Published!)
    var imageData: Data?
    var isLoadingImage = false

    // MARK: - Public read-only
    let user: User
    var id: String { user.id.uuidString }
    var displayName: String { user.fullName }

    // MARK: - Dependencies
    @ObservationIgnored // <-- Tells the macro not to track this
    private let imageService: ImageServiceProtocol

    init(user: User, imageService: ImageServiceProtocol) {
        self.user = user
        self.imageService = imageService
    }

    // MARK: - Image Loading
    func loadImage() async {
        guard imageData == nil, !isLoadingImage else { return }
        isLoadingImage = true
        defer { isLoadingImage = false }
        imageData = await imageService.loadImage(from: user.picture.thumbnail)
    }

    // MARK: - Display Rows
    func infoRows(for settings: Settings) -> [(icon: String, label: String, value: String)] {
        // (Keep your exact same infoRows logic here - it is perfect)
        var rows: [(String, String, String)] = []

        if settings.showGender, let gender = user.gender {
            rows.append(("person.fill", "Gender", gender.capitalized))
        }
        if settings.showEmail, let email = user.email {
            rows.append(("envelope.fill", "Email", email))
        }
        if settings.showPhone, let phone = user.phone {
            rows.append(("phone.fill", "Phone", phone))
        }
        if settings.showCell, let cell = user.cell {
            rows.append(("iphone", "Cell", cell))
        }
        if settings.showNationality, let nat = user.nat {
            rows.append(("flag.fill", "Nationality", nat))
        }
        if settings.showDob, let dob = user.dob {
            let age = dob.age.map { "\($0) yrs" } ?? ""
            rows.append(("birthday.cake.fill", "Birthday", "\(dob.formattedDate)  \(age)"))
        }
        if settings.showRegistered, let reg = user.registered {
            let age = reg.age.map { "\($0) yrs ago" } ?? ""
            rows.append(("calendar.badge.plus", "Registered", age))
        }
        if settings.showLogin, let login = user.login, let username = login.username {
            rows.append(("person.circle.fill", "Username", username))
        }
        if settings.showID, let idInfo = user.idInfo {
            let idName = idInfo.name ?? ""
            let idValue = idInfo.value ?? "N/A"
            rows.append(("person.text.rectangle.fill", "ID", "\(idName) \(idValue)"))
        }
        if settings.showLocation, let location = user.location {
            rows.append(("location.fill", "Location", location.formattedAddress))
        }

        return rows
    }
}

