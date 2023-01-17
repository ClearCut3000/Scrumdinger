//
//  MeetingFooterView.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 10.01.2023.
//

import SwiftUI

struct MeetingFooterView: View {

  //MARK: - View Dependencies
  let speakers: [ScrumTimer.Speaker]
  var skipAction: ()->Void
  private var speakerNumber: Int? {
      guard let index = speakers.firstIndex(where: { !$0.isCompleted }) else { return nil}
      return index + 1
  }
  private var isLastSpeaker: Bool {
      return speakers.dropLast().allSatisfy { $0.isCompleted }
  }
  private var speakerText: String {
      guard let speakerNumber = speakerNumber else { return "No more speakers" }
      return "Speaker \(speakerNumber) of \(speakers.count)"
  }

  //MARK: - View Body
  var body: some View {
    VStack {
      HStack {
        if isLastSpeaker {
          Text(speakerText)
        } else {
          Text(speakerText)
          Spacer()
          Button(action: skipAction) {
            Image(systemName: "forward.fill")
          }
          .accessibilityLabel("Next Speaker")
        }
      }
    }
    .padding([.bottom, .horizontal])
  }
}

struct MeetingFooterView_Previews: PreviewProvider {
  static var previews: some View {
    MeetingFooterView(speakers: DailyScrum.sampleData[0].attendees.speakers, skipAction: { })
      .previewLayout(.sizeThatFits)
  }
}
