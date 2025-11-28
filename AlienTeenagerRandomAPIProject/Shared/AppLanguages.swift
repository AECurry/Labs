//
//  AppLanguages.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/20/25.
//

import SwiftUI

struct AlienGreeting {
    let topText: String
    let bottomText: String
    let color: Color
}

extension AlienGreeting {
    static let allGreetings: [AlienGreeting] = [
        // English
        AlienGreeting(
            topText: "Welcome to Earth",
            bottomText: "Come discover our World!",
            color: .white
        ),
        
        // Spanish
        AlienGreeting(
            topText: "Bienvenido a la Tierra",
            bottomText: "¡Ven a descubrir nuestro Mundo!",
            color: .white
        ),
        
        // French
        AlienGreeting(
            topText: "Bienvenue sur Terre",
            bottomText: "Venez découvrir notre Monde!",
            color: .white
        ),
        
        // German
        AlienGreeting(
            topText: "Willkommen auf der Erde",
            bottomText: "Komm entdecke unsere Welt!",
            color: .white
        ),
        
        // Japanese
        AlienGreeting(
            topText: "地球へようこそ",
            bottomText: "私たちの世界を発見しに来てください！",
            color: .white
        ),
        
        // Klingon
        AlienGreeting(
            topText: "nuqneH tera'",
            bottomText: "yIjang jIH mol!",
            color: .white
        ),
        
        // Alienese
        AlienGreeting(
            topText: "Zorp Blorg Glorp",
            bottomText: "Floo Blarg Snarf Woop!",
            color: .white
        )
    ]
}
