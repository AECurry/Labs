//
//  ModelContext+Extensions.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/18/26.
//

import SwiftData
import Foundation

extension ModelContext {
    func safeSave() {
        do {
            try self.save()
            print("ModelContext saved successfully")
        } catch {
            print("Failed to save ModelContext: \(error)")
        }
    }
}
