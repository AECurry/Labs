//
//  CardCreationViewModel.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI
import SwiftData

@Model
class BirthdayCard {
    var id: UUID
    var cardTitle: String
    var partyDescription: String
    var descriptionFontSize: Double // Store as CGFloat
    var descriptionTextColorRed: Double
    var descriptionTextColorGreen: Double
    var descriptionTextColorBlue: Double
    var descriptionTextColorAlpha: Double
    var date: Date
    var themeColor: ThemeColor?
    var imageData: Data?
    var createdAt: Date
    
    init(id: UUID = UUID(),
         cardTitle: String = "",
         partyDescription: String = "",
         descriptionFontSize: Double = 16, // Default medium
         descriptionTextColorRed: Double = 0, // Default black
         descriptionTextColorGreen: Double = 0,
         descriptionTextColorBlue: Double = 0,
         descriptionTextColorAlpha: Double = 1,
         date: Date = Date(),
         themeColor: ThemeColor? = nil,
         imageData: Data? = nil,
         createdAt: Date = Date()) {
        self.id = id
        self.cardTitle = cardTitle
        self.partyDescription = partyDescription
        self.descriptionFontSize = descriptionFontSize
        self.descriptionTextColorRed = descriptionTextColorRed
        self.descriptionTextColorGreen = descriptionTextColorGreen
        self.descriptionTextColorBlue = descriptionTextColorBlue
        self.descriptionTextColorAlpha = descriptionTextColorAlpha
        self.date = date
        self.themeColor = themeColor
        self.imageData = imageData
        self.createdAt = createdAt
    }
    
    // Computed property for text color
    var descriptionTextColor: Color {
        Color(
            red: descriptionTextColorRed,
            green: descriptionTextColorGreen,
            blue: descriptionTextColorBlue,
            opacity: descriptionTextColorAlpha
        )
    }
    
    // Helper to update text color
    func updateTextColor(_ color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        descriptionTextColorRed = Double(r)
        descriptionTextColorGreen = Double(g)
        descriptionTextColorBlue = Double(b)
        descriptionTextColorAlpha = Double(a)
    }
}
