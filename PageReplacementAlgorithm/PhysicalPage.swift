//
//  PhysicalPage.swift
//  PageReplacementAlgorithm
//
//  Created by Anastasia Holovash on 07.12.2021.
//

import Foundation

final class PhysicalPage {
    
    // MARK: - Properties
    
    var p: Bool
    weak var virtualPage: VirtualPage?
    
    // MARK: - Lifecycle
    
    init(p: Bool, vp: VirtualPage? = nil) {
        self.p = p
        self.virtualPage = vp
    }
    
    // MARK: - Accessible methods
    
    func free() {
        p = false
        virtualPage = nil
    }
}
