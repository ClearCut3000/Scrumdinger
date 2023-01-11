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
  @State private var isPresentingNewScrumView = false
  @State private var newScrumData = DailyScrum.Data()

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
      Button(action: {
        isPresentingNewScrumView = true
      }) {
        Image(systemName: "plus")
      }
      .accessibilityLabel("New Scrum")
    }
    .sheet(isPresented: $isPresentingNewScrumView) {
      NavigationView {
        DetailEditView(data: $newScrumData)
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Dismiss") {
                isPresentingNewScrumView = false
                newScrumData = DailyScrum.Data()
              }
            }
            ToolbarItem(placement: .confirmationAction) {
              Button("Add") {
                let newScrum = DailyScrum(data: newScrumData)
                scrums.append(newScrum)
                isPresentingNewScrumView = false
                newScrumData = DailyScrum.Data()
              }
            }
          }
      }
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
