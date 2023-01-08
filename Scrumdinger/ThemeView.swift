//
//  ThemeView.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 08.01.2023.
//

import SwiftUI

struct ThemeView: View {

  //MARK: - View Properties
  let theme: Theme

  //MARK: - View Body
    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 4)
          .fill(theme.mainColor)
        Label(theme.name, systemImage: "paintpalette")
          .padding(4)
      }
      .foregroundColor(theme.accentColor)
      .fixedSize(horizontal: false, vertical: true)
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
      ThemeView(theme: .bubblegum)
    }
}
