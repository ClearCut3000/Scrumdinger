//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 04.01.2023.
//

import SwiftUI

struct ScrumsView: View {

  //MARK: - View Dependencies
  @Binding var scrums: [DailyScrum]

  //MARK: - View Body
  var body: some View {
    List {
      ForEach($scrums) { $scrum in
        NavigationLink(destination: DetailView(scrum: $scrum)) {
          CardView(scrum: scrum)
            .listRowBackground(scrum.theme.mainColor)
        }
        .listRowBackground(scrum.theme.mainColor)
      }
    }
    .navigationTitle("Daily Scrums")
    .toolbar {
      Button(action: {}) {
        Image(systemName: "plus")
      }
      .accessibilityLabel("New Scrum")
    }
  }
}

struct ScrumsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ScrumsView(scrums: .constant(DailyScrum.sampleData))
    }
  }
}
