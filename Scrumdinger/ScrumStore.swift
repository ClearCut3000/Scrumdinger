//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 12.01.2023.
//

import Foundation
import SwiftUI

class ScrumStore: ObservableObject {
  @Published var scrums: [DailyScrum] = []

  private static func fileURL() throws -> URL {
    try FileManager.default.url(for: .documentDirectory,
                                in: .userDomainMask,
                                appropriateFor: nil,
                                create: false)
    .appendingPathComponent("scrums.data")
  }

  /// async load method
  static func load() async throws -> [DailyScrum] {
    try await withCheckedThrowingContinuation { continuation in
      load { result in
        switch result {
        case .success(let success):
          continuation.resume(returning: success)
        case .failure(let failure):
          continuation.resume(throwing: failure)
        }
      }
    }
  }

  static func load(completion: @escaping (Result<[DailyScrum], Error>)->Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let fileURL = try fileURL()
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
          /// Because scrums.data doesn’t exist when a user launches the app for the first time,
          /// call the completion handler with an empty array if there’s an error opening the file handle.
          DispatchQueue.main.async {
            completion(.success([]))
          }
          return
        }
        let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: file.availableData)
        DispatchQueue.main.async {
          completion(.success(dailyScrums))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }

  /// async save meethod
  @discardableResult
  static func save(scrums: [DailyScrum]) async throws -> Int {
    try await withCheckedThrowingContinuation({ continuation in
      save(scrums: scrums) { result in
        switch result {
        case .success(let success):
          continuation.resume(returning: success)
        case .failure(let failure):
          continuation.resume(throwing: failure)
        }
      }
    })
  }

  static func save(scrums: [DailyScrum], completion: @escaping (Result<Int, Error>)->Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let data = try JSONEncoder().encode(scrums)
        let outfile = try fileURL()
        try data.write(to: outfile)
        DispatchQueue.main.async {
          completion(.success(scrums.count))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
}

