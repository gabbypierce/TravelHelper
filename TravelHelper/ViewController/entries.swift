//
//  entries.swift
//  TravelHelper
//
//  Created by Gabby Pierce on 3/18/24.
//

import Foundation

func saveEntryToFile(entry: String, filename: String) {
    let fileManager = FileManager.default
    let documentsDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    let fileURL = documentsDirectory?.appendingPathComponent(filename)

    do {
        try entry.appendLineToURL(fileURL: fileURL)
        print("User's entry saved to \(filename)")
    } catch {
        print("Error saving user's entry: \(error)")
    }
}

extension String {
    func appendLineToURL(fileURL: URL?) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }

    func appendToURL(fileURL: URL?) throws {
        guard let fileURL = fileURL else { return }
        try self.write(to: fileURL, atomically: true, encoding: .utf8)
    }
}

