//
//  NobelPrizeData.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/24/25.
//

import Foundation

struct NobelPrizeData {
    static let samplePrizes = [
        NobelPrizeCardData(
            year: "2020",
            category: "peace",
            winner: "World Food Programme",
            motivation: "For efforts to combat hunger and promote peace"
        ),
        NobelPrizeCardData(
            year: "2019",
            category: "chemistry",
            winner: "John B. Goodenough, M. Stanley Whittingham, Akira Yoshino",
            motivation: "For the development of lithium-ion batteries"
        ),
        NobelPrizeCardData(
            year: "2018",
            category: "physics",
            winner: "Arthur Ashkin, Gérard Mourou, Donna Strickland",
            motivation: "For groundbreaking inventions in laser physics"
        )
    ]
}

struct NobelPrizeCardData {
    let year: String
    let category: String
    let winner: String
    let motivation: String
}

