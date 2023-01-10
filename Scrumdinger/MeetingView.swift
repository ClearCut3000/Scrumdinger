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
  @StateObject var scrumTimer = ScrumTimer()

  //MARK: - View Body
    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 16)
          .fill(scrum.theme.mainColor)
        VStack {
          MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed,
                            secondsRemaining: scrumTimer.secondsRemaining,
                            theme: scrum.theme)
          Circle()
            .strokeBorder(lineWidth: 24)
          MeetingFooterView(speakers: scrumTimer.speakers) {
            scrumTimer.skipSpeaker()
          }
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .onAppear(perform: {
          scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
          scrumTimer.startScrum()
        })
        .onDisappear(perform: {
          scrumTimer.stopScrum()
        })
        .navigationBarTitleDisplayMode(.inline)
      }
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
      MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
