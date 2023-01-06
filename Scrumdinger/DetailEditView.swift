//
//  DetailEditView.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 07.01.2023.
//

import SwiftUI

struct DetailEditView: View {

  //MARK: - View Properties
  @State private var data = DailyScrum.Data()

  //MARK: - View Body
  var body: some View {
    Form {
      Section(header: Text("Meeting Info")) {
        TextField("Title", text: $data.title)
        HStack {
          Slider(value: $data.lengthInMinutes, in: 5...30, step: 1) {
            Text("Length")
          }
          Spacer()
          Text("\(Int(data.lengthInMinutes)) minutes")
        }
      }
    }
  }
}

struct DetailEditView_Previews: PreviewProvider {
  static var previews: some View {
    DetailEditView()
  }
}