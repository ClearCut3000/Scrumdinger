//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 03.01.2023.
//

import SwiftUI

@main
struct ScrumdingerApp: App {

  //MARK: - View Dependencies
  @StateObject private var store = ScrumStore()

  //MARK: - View Body
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ScrumsView(scrums: $store.scrums) {
          Task {
            do {
              try await ScrumStore.save(scrums: store.scrums)
            } catch {
              fatalError("Error saving scrums.")
            }
          }
        }
      }
      .onAppear {
        ScrumStore.load { result in
          switch result {
          case .success(let success):
            store.scrums = success
          case .failure(let failure):
            fatalError(failure.localizedDescription)
          }
        }
      }
      .task {
        do {
          store.scrums = try await ScrumStore.load()
        } catch {
          fatalError("Error loading scrums.")
        }
      }
    }
  }
}
