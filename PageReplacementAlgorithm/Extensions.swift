//
//  Extensions.swift
//  PageReplacementAlgorithm
//
//  Created by Anastasia Holovash on 07.12.2021.
//

import Foundation

// MARK: Double Extension

extension Double {
    
    static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
}

extension Int {
    
    var string: String {
        return String(self)
    }
}

extension String {
    
    func padding(_ length: Int) -> String {
        return padding(toLength: length, withPad: " ", startingAt: 0)
    }
}
