//
//  DoubleExtensions.swift
//  MASUKI
//
//  Created by AnnElaine on 1/28/26.
//

import Foundation

extension Double {
    func toDistanceString(useMetric: Bool) -> String {
        if useMetric {
            return String(format: "%.1f km", self * 1.60934)
        }
        return String(format: "%.1f mi", self)
    }
    
    func toDistanceValue(useMetric: Bool) -> Double {
        if useMetric {
            return self * 1.60934
        }
        return self
    }
    
    func toDistanceUnit(useMetric: Bool) -> String {
        return useMetric ? "km" : "mi"
    }
}

