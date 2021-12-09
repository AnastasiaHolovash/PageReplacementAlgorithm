//
//  Constants.swift
//  PageReplacementAlgorithm
//
//  Created by Anastasia Holovash on 07.12.2021.
//

import Foundation

struct Constants {
    
    static let programTicks = 400
    static let physicalMemoryPages = 12
    
    // MARK: - Kernel
    
    struct Kernel {
        static let minVirtualMemoryPages = 6
        static let maxVirtualMemoryPages = 14
    }
    
    // MARK: - Process
    
    struct Process {
        static let numberOfProcess = 6
        static let minWorkTime = 30
        static let maxWorkTime = 35
        static let quantDuration = 5
        static let pageAccessProbability = 0.5
        static let pageModifyProbability = 0.3
    }
    
    // MARK: - WorkingSet
    
    struct WorkingSet {
        static let pages = 3
        static let accessProbability = 0.9
        static let timeToLive = 25
    }
    
}
