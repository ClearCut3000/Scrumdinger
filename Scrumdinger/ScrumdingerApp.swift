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
  @State private var scrums = DailyScrum.sampleData

  //MARK: - View Body
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ScrumsView(scrums: $scrums)
      }
    }
  }
}
