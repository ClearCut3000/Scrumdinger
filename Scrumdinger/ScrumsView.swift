//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 04.01.2023.
//

import SwiftUI

struct ScrumsView: View {

  //MARK: - View Properties
  let scrums: [DailyScrum]

  //AMRK: - View Body
  var body: some View {
    List {
      ForEach(scrums) { scrum in
        CardView(scrum: scrum)
          .listRowBackground(scrum.theme.mainColor)
      }
    }
  }
}

struct ScrumsView_Previews: PreviewProvider {
  static var previews: some View {
    ScrumsView(scrums: DailyScrum.sampleData)
  }
}
