//
//  Process.swift
//  PageReplacementAlgorithm
//
//  Created by Anastasia Holovash on 07.12.2021.
//

import Foundation

final class Process {
    
    // MARK: - Properties
    
    let id: Int
    var processTime: Int
    var pageTable: [VirtualPage]
    var workingSet: [VirtualPage] = []
    var nonWorkingSet: [VirtualPage] = []
    
    var workedTime: Int {
        didSet {
            isFinished = processTime == workedTime
        }
    }
    
    var isFinished: Bool {
        didSet {
            
        }
    }
    
    // MARK: - Lifecycle
    
    init(id: Int, pageTable: [VirtualPage]) {
        self.id = id
        self.processTime = Int.random(
            in: Constants.Process.minWorkTime...Constants.Process.maxWorkTime
        )
        self.workedTime = 0
        self.isFinished = false
        self.pageTable = pageTable
        
        createWorkingSet(for: pageTable)
    }
    
    // MARK: - Accessible methods
    
    public func accessPage() {
        workedTime += 1
        guard Double.random > Constants.Process.pageAccessProbability,
              let page = getAccessPage() else {
            return
        }
        
        Double.random < Constants.Process.pageModifyProbability
        ? MMU.shared.accessPage(page, for: self, accessType: .modify)
        : MMU.shared.accessPage(page, for: self, accessType: .read)
    }
    
    public func updateWorkingSet() {
        createWorkingSet(for: pageTable)
    }
    
    // MARK: - Private methods
    
    private func getAccessPage() -> VirtualPage? {
        if Double.random < Constants.WorkingSet.accessProbability {
            Logger.shared.logWorkingSetPageAccess(processId: id, tick: tick)
            return workingSet.randomElement()
        } else {
            Logger.shared.logNonWorkingSetPageAccess(processId: id, tick: tick)
            return nonWorkingSet.randomElement()
        }
    }
    
    private func createWorkingSet(for pageTable: [VirtualPage]) {
        pageTable.forEach { page in
            Double.random < 0.5 ? workingSet.append(page) : nonWorkingSet.append(page)
        }
    }
    
    private func freeMemory() {
        MMU.shared.freeMemory(for: self)
    }
}
