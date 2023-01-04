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

  //MARK: - View Body
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView {
        DetailView(scrum: DailyScrum.sampleData[0])
      }
    }
}
