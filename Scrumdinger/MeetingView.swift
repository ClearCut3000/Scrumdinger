//
//  MeetingView.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 03.01.2023.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {

  //MARK: - View Dependencies
  @Binding var scrum: DailyScrum
  @StateObject var scrumTimer = ScrumTimer()
  @StateObject var speechRecognizer = SpeechRecognizer()
  @State private var isRecording = false
  private var player: AVPlayer { AVPlayer.sharedDingPlayer }

  //MARK: - View Body
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(scrum.theme.mainColor)
      VStack {
        MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed,
                          secondsRemaining: scrumTimer.secondsRemaining,
                          theme: scrum.theme)
        MeetingTimerView(speakers: scrumTimer.speakers, theme: scrum.theme)
        MeetingFooterView(speakers: scrumTimer.speakers) {
          scrumTimer.skipSpeaker()
        }
      }
      .padding()
      .foregroundColor(scrum.theme.accentColor)
      .onAppear(perform: {
        scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
        scrumTimer.speakerChangedAction = {
          player.seek(to: .zero)
          player.play()
        }
        speechRecognizer.reset()
        speechRecognizer.transcribe()
        isRecording = true
        scrumTimer.startScrum()
      })
      .onDisappear(perform: {
        scrumTimer.stopScrum()
        speechRecognizer.stopTranscribing()
        isRecording = false
        let newHistory = History(attendees: scrum.attendees,
                                 lengthInMinutes: scrum.timer.secondsElapsed / 60)
        scrum.history.insert(newHistory, at: 0)
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
