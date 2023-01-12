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
          ScrumStore.save(scrums: store.scrums) { result in
            if case .failure(let failure) = result {
              fatalError(failure.localizedDescription)
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
    }
  }
}
