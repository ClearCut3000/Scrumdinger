//
//  ThemePicker.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 08.01.2023.
//

import SwiftUI

struct ThemePicker: View {

  //MARK: - View Dependencies
  @Binding var selection: Theme

  //MARK: - View Body
  var body: some View {
    Picker("Theme", selection: $selection) {
      ForEach(Theme.allCases) { theme in
        ThemeView(theme: theme)
          .tag(theme)
      }
    }
    .pickerStyle(.navigationLink)
  }
}

struct ThemePicker_Previews: PreviewProvider {
  static var previews: some View {
    ThemePicker(selection: .constant(.periwinkle))
  }
}
