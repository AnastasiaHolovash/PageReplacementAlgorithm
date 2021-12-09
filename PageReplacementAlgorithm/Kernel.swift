//
//  Kernel.swift
//  PageReplacementAlgorithm
//
//  Created by Anastasia Holovash on 07.12.2021.
//

import Foundation

var tick: Int = 0

final class Kernel {
        
    static let shared = Kernel()
    private init() { }
    
    // MARK: - Private properties
    
    private var processes: [Process] = []
    private var currentProcess: Process?
    private var clockArrow: Int = 0
    
    // MARK: - Accessible methods
    
    func start() {
        // Create process + page tables; start process
        processes = (1...Constants.Process.numberOfProcess).map { processID in
            Process(
                id: processID,
                pageTable: (0..<randomNumberOfPages).map { _ in VirtualPage() }
            )
        }
        
        startNewProcessIfNeeded()
        
        while tick < Constants.programTicks {
            currentProcess?.accessPage()
            startNewProcessIfNeeded()
            tick += 1
        }
        
        Logger.shared.printStats()
    }
    
    public func pageFault(for process: Process) -> PhysicalPage {
        Logger.shared.logPageFault(processId: process.id, tick: tick)
        
        if MMU.shared.freePhysicalPages.isEmpty {
            Logger.shared.logReplacedByClockAlgorithm(processId: process.id, tick: tick)
            return clockAlgorithm(physicalPages: MMU.shared.physicalPages)
        } else {
            Logger.shared.logUsedFreePage(processId: process.id, tick: tick)
            return MMU.shared.freePhysicalPages.removeFirst()
        }
    }
    
    // MARK: - Private methods
    
    private func clockAlgorithm(physicalPages: [PhysicalPage]) -> PhysicalPage {
        while true {
            if let virtualPage = physicalPages[clockArrow].virtualPage,
               !virtualPage.r {
                return physicalPages[clockArrow]
            } else {
                physicalPages[clockArrow].virtualPage?.r = false
                clockArrow = clockArrow == physicalPages.count - 1 ? 0 : clockArrow + 1
            }
        }
    }
    
    private func startNewProcessIfNeeded() {
        if tick % Constants.Process.quantDuration == 0 {
            currentProcess = processes.filter { !$0.isFinished }.randomElement()
        }
    }
}

extension Kernel {
    
    var randomNumberOfPages: Int {
        Int.random(in: Constants.Kernel.minVirtualMemoryPages...Constants.Kernel.maxVirtualMemoryPages)
    }
    
}
