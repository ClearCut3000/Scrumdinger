//
//  DetailEditView.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 07.01.2023.
//

import SwiftUI

struct DetailEditView: View {

  //MARK: - View Dependencies
  @Binding var data: DailyScrum.Data
  @State private var newAttendeeName = ""

  //MARK: - View Body
  var body: some View {
    Form {
      Section(header: Text("Meeting Info")) {
        TextField("Title", text: $data.title)
        HStack {
          Slider(value: $data.lengthInMinutes, in: 5...30, step: 1) {
            Text("Length")
          }
          .accessibilityValue("\(Int(data.lengthInMinutes)) minutes")
          Spacer()
          Text("\(Int(data.lengthInMinutes)) minutes")
            .accessibilityHidden(true)
        }
        ThemePicker(selection: $data.theme)
      }
      Section(header: Text("Attendees")) {
        ForEach(data.attendees) { attendee in
          Text(attendee.name)
        }
        .onDelete { indices in
          data.attendees.remove(atOffsets: indices)
        }
        HStack {
          TextField("New Attendee", text: $newAttendeeName)
          Button(action: {
            withAnimation {
              let attendee = DailyScrum.Attendee(name: newAttendeeName)
              data.attendees.append(attendee)
              newAttendeeName = ""
            }
          }) {
            Image(systemName: "plus.circle.fill")
              .accessibilityLabel("Add attendee")
          }
          .disabled(newAttendeeName.trimmingCharacters(in: .whitespaces).isEmpty)
        }
      }
    }
  }
}

struct DetailEditView_Previews: PreviewProvider {
  static var previews: some View {
    DetailEditView(data: .constant(DailyScrum.sampleData[0].data))
  }
}
