//
//  AnimatedImageConfig.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

import SwiftUI

// ==========================================
// MARK: - ANIMATED IMAGE CONFIGURATION MODEL
// ==========================================

struct AnimatedImageConfig: Identifiable {
    // MARK: - Core Identification Properties
    let id: String
    let name: String
    let imageName: String
    let description: String
    
    // MARK: - Default Animation Settings
    let defaultRotationSpeed: Double
    let defaultMinScale: Double
    let defaultMaxScale: Double
    let defaultScaleSpeed: Double
    
    // MARK: - UserDefaults Key Generators
    var userRotationSpeedKey: String { "\(id)_rotationSpeed" }
    var userMinScaleKey: String { "\(id)_minScale" }
    var userMaxScaleKey: String { "\(id)_maxScale" }
    var userScaleSpeedKey: String { "\(id)_scaleSpeed" }
    var rotationEnabledKey: String { "\(id)_rotationEnabled" }
    var scaleEnabledKey: String { "\(id)_scaleEnabled" }
    
    // MARK: - Computed Properties (User Custom OR Default)
    var rotationSpeed: Double {
        let userValue = UserDefaults.standard.double(forKey: userRotationSpeedKey)
        return userValue > 0 ? userValue : defaultRotationSpeed
    }
    
    var minScale: Double {
        let userValue = UserDefaults.standard.double(forKey: userMinScaleKey)
        return userValue > 0 ? userValue : defaultMinScale
    }
    
    var maxScale: Double {
        let userValue = UserDefaults.standard.double(forKey: userMaxScaleKey)
        return userValue > 0 ? userValue : defaultMaxScale
    }
    
    var scaleSpeed: Double {
        let userValue = UserDefaults.standard.double(forKey: userScaleSpeedKey)
        return userValue > 0 ? userValue : defaultScaleSpeed
    }
    
    var isRotationEnabled: Bool {
        if UserDefaults.standard.object(forKey: rotationEnabledKey) == nil {
            return true
        }
        return UserDefaults.standard.bool(forKey: rotationEnabledKey)
    }
    
    var isScaleEnabled: Bool {
        if UserDefaults.standard.object(forKey: scaleEnabledKey) == nil {
            return true
        }
        return UserDefaults.standard.bool(forKey: scaleEnabledKey)
    }
    
    // MARK: - Initializer
    init(
        id: String,
        name: String,
        imageName: String,
        description: String,
        defaultRotationSpeed: Double = 20.0,
        defaultMinScale: Double = 0.95,
        defaultMaxScale: Double = 1.16,
        defaultScaleSpeed: Double = 20.0
    ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.description = description
        self.defaultRotationSpeed = defaultRotationSpeed
        self.defaultMinScale = defaultMinScale
        self.defaultMaxScale = defaultMaxScale
        self.defaultScaleSpeed = defaultScaleSpeed
    }
    
    // MARK: - User Customization Methods
    func saveRotationSpeed(_ speed: Double) {
        UserDefaults.standard.set(speed, forKey: userRotationSpeedKey)
    }
    
    func saveMinScale(_ scale: Double) {
        UserDefaults.standard.set(scale, forKey: userMinScaleKey)
    }
    
    func saveMaxScale(_ scale: Double) {
        UserDefaults.standard.set(scale, forKey: userMaxScaleKey)
    }
    
    func saveScaleSpeed(_ speed: Double) {
        UserDefaults.standard.set(speed, forKey: userScaleSpeedKey)
    }
    
    func saveRotationEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: rotationEnabledKey)
    }
    
    func saveScaleEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: scaleEnabledKey)
    }
    
    // MARK: - Reset Method
    func resetToDefaults() {
        UserDefaults.standard.removeObject(forKey: userRotationSpeedKey)
        UserDefaults.standard.removeObject(forKey: userMinScaleKey)
        UserDefaults.standard.removeObject(forKey: userMaxScaleKey)
        UserDefaults.standard.removeObject(forKey: userScaleSpeedKey)
        UserDefaults.standard.removeObject(forKey: rotationEnabledKey)
        UserDefaults.standard.removeObject(forKey: scaleEnabledKey)
    }
}

// ==========================================
// MARK: - ANIMATED IMAGE LIBRARY
// ==========================================

struct AnimatedImageLibrary {
    static let availableImages: [AnimatedImageConfig] = [
        AnimatedImageConfig(
            id: "koi",
            name: "Koi Fish",
            imageName: "JapaneseKoi",
            description: "Two koi swimming in harmony",
            defaultRotationSpeed: 24.0,
            defaultMinScale: 0.95,
            defaultMaxScale: 1.16,
            defaultScaleSpeed: 20.0
        )
    ]
    
    static func getImage(byId id: String) -> AnimatedImageConfig? {
        return availableImages.first { $0.id == id }
    }
    
    static func getCurrentImage() -> AnimatedImageConfig {
        let selectedId = UserDefaults.standard.string(forKey: "selectedImageId") ?? "koi"
        return getImage(byId: selectedId) ?? availableImages.first!
    }
    
    static func setCurrentImage(id: String) {
        UserDefaults.standard.set(id, forKey: "selectedImageId")
    }
    
    static func resetAllImagesToDefaults() {
        availableImages.forEach { $0.resetToDefaults() }
    }
}

