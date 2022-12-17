//
//  Collection.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 17/12/2022.
//

import Foundation

extension Collection {
    // MARK: - Safe index
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    // MARK: - Run forEach in parallel
    func forEachInParallel(_ each: (Self.Element) -> Void) {
        DispatchQueue.concurrentPerform(iterations: count) {
            each(self[index(startIndex, offsetBy: $0)])
        }
    }
    
    // MARK: - Get all indices where condition is met
    func indices(where condition: (Element) throws -> Bool) rethrows -> [Index]? {
        let indices = try self.indices.filter { try condition(self[$0]) }
        return indices.isEmpty ? nil : indices
    }
}
