//
//  MeetingTimerView.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 16.01.2023.
//

import SwiftUI

struct MeetingTimerView: View {
  
  //MARK: - View Dependencies
  let speakers: [ScrumTimer.Speaker]
  let theme: Theme
  private var currentSpeaker: String {
    speakers.first(where: { !$0.isCompleted })?.name ?? "Someone"
  }
  
  //MARK: - View Body
  var body: some View {
    Circle()
      .strokeBorder(lineWidth: 24)
      .overlay {
        VStack {
          Text(currentSpeaker)
            .font(.title)
          Text("is speaking")
        }
        .accessibilityElement(children: .combine)
        .foregroundStyle(theme.accentColor)
      }
  }
}

struct MeetingTimerView_Previews: PreviewProvider {
  static var speakers: [ScrumTimer.Speaker] { [ScrumTimer.Speaker(name: "Bill", isCompleted: true),
                                               ScrumTimer.Speaker(name: "Cathy", isCompleted: false)]
  }
  static var previews: some View {
    MeetingTimerView(speakers: speakers, theme: .yellow)
  }
}
