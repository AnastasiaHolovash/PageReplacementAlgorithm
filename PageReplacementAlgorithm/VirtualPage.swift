//
//  VirtualPage.swift
//  PageReplacementAlgorithm
//
//  Created by Anastasia Holovash on 07.12.2021.
//

import Foundation

final class VirtualPage {
    
    var p: Bool
    var r: Bool
    var m: Bool
    var physicalPage: PhysicalPage?
    
    // MARK: - Lifecycle
    
    init(
        p: Bool = false,
        r: Bool = false,
        m: Bool = false,
        physicalPage: PhysicalPage? = nil
    ) {
        self.p = p
        self.r = r
        self.m = m
        self.physicalPage = physicalPage
    }
    
    // MARK: - Accessible methods
    
    public func free() {
        p = false
        r = false
        m = false
        physicalPage = nil
    }
}
