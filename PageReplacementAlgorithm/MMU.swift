//
//  MMU.swift
//  PageReplacementAlgorithm
//
//  Created by Anastasia Holovash on 07.12.2021.
//

import Foundation

final class MMU {
    
    // MARK: - Properties
    
    public let physicalPages: [PhysicalPage]
    public var freePhysicalPages: [PhysicalPage]
    
    // MARK: - Singletone
    
    static let shared = MMU()
    
    private init() {
        physicalPages = (0..<Constants.physicalMemoryPages).map { _ in
            PhysicalPage(p: false, vp: nil)
        }
        freePhysicalPages = physicalPages
    }
    
    // MARK: - Accessible methods
    
    func freeMemory(for process: Process) {
        Logger.shared.logFreeingMemory(processId: process.id, tick: tick)
        process.pageTable.forEach {
            $0.physicalPage?.free()
            
            if let freePage = $0.physicalPage{
                freePhysicalPages.append(freePage)
            }
            
            $0.free()
        }
    }
    
    public func accessPage(_ virtualPage: VirtualPage, for process: Process, accessType: AccessType) {
        if !virtualPage.p {
            let selectedPage = Kernel.shared.pageFault(for: process)
            if let pageToEvict = selectedPage.virtualPage {
                evictPage(virtualPage: pageToEvict, for: process)
            }
            
            selectedPage.p = true
            selectedPage.virtualPage = virtualPage
            
            virtualPage.p = true
            virtualPage.physicalPage = selectedPage
        }
        
        switch accessType {
        case .read:
            Logger.shared.logPageRead(processId: process.id, tick: tick)
            virtualPage.r = true
            
        case .modify:
            Logger.shared.logPageModification(processId: process.id, tick: tick)
            virtualPage.r = true
            virtualPage.m = true
        }
    }
    
    // MARK: - Private methods
    
    private func evictPage(virtualPage: VirtualPage, for process: Process) {
        if virtualPage.m {
            Logger.shared.logDirtyPageWriteToDisc(processId: process.id, tick: tick)
        }
        
        virtualPage.free()
    }
    
}

// MARK: - Declarations

extension MMU {
    
    enum AccessType {
        case read
        case modify
    }
    
}
