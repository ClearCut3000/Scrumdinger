//
//  DetailView.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 04.01.2023.
//

import SwiftUI

struct DetailView: View {
  
  //MARK: - View Properties
  let scrum: DailyScrum
  @State private var isPresentingEditView = false
  
  //MARK: - View Body
  var body: some View {
    List {
      /// Meeting Info Section
      Section(header: Text("Meeting Info")) {
        NavigationLink(destination: MeetingView()) {
          Label("Start Meeting", systemImage: "timer")
            .font(.headline)
            .foregroundColor(.accentColor)
        }
        HStack {
          Label("Length", systemImage: "clock")
          Spacer()
          Text("\(scrum.lengthInMinutes) minutes")
        }
        .accessibilityElement(children: .combine)
        HStack {
          Label("Theme", systemImage: "paintpalette")
          Spacer()
          Text(scrum.theme.name)
            .padding(4)
            .foregroundColor(scrum.theme.accentColor)
            .background(scrum.theme.mainColor)
            .cornerRadius(4)
        }
        .accessibilityElement(children: .combine)
      }
      /// Attendees Section
      Section(header: Text("Attendees")) {
        ForEach(scrum.attendees) { attendee in
          Label(attendee.name, systemImage: "person")
        }
      }
    }
    .navigationTitle(scrum.title)
    .toolbar {
      Button("Edit") {
        isPresentingEditView = true
      }
    }
    .sheet(isPresented: $isPresentingEditView) {
      NavigationView {
        DetailEditView()
          .navigationTitle(scrum.title)
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                isPresentingEditView = false
              }
            }
            ToolbarItem(placement: .confirmationAction) {
              Button("Done") {
                isPresentingEditView = false
              }
            }
          }
      }
    }
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DetailView(scrum: DailyScrum.sampleData[0])
    }
  }
}
