//
//  MeetingView.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 03.01.2023.
//

import SwiftUI

struct MeetingView: View {

  //MARK: - View Dependencies
  @Binding var scrum: DailyScrum

  //MARK: - View Body
    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 16)
          .fill(scrum.theme.mainColor)
        VStack {

          Circle()
            .strokeBorder(lineWidth: 24)
          HStack {
            Text("Speaker 1 of 3")
            Spacer()
            Button(action: { }) {
              Image(systemName: "forward.fill")
            }
          }
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .navigationBarTitleDisplayMode(.inline)
      }
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
      MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
