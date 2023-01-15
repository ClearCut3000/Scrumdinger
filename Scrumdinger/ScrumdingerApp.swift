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
  @State private var errorWrapper: ErrorWrapper?
  
  //MARK: - View Body
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ScrumsView(scrums: $store.scrums) {
          Task {
            do {
              try await ScrumStore.save(scrums: store.scrums)
            } catch {
              errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
            }
          }
        }
      }
      .task {
        do {
          store.scrums = try await ScrumStore.load()
        } catch {
          errorWrapper = ErrorWrapper(error: error, guidance: "Scrumdinger will load sample data and continue.")
        }
      }
      .sheet(item: $errorWrapper) {
        store.scrums = DailyScrum.sampleData
      } content: { wrapper in
        ErrorView(errorWrapper: wrapper)
      }
    }
  }
}
