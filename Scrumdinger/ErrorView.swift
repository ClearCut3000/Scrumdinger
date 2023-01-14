//
//  ErrorView.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 13.01.2023.
//

import SwiftUI

struct ErrorView: View {

  //MARK: - View Dependencies
  let errorWrapper: ErrorWrapper

  //MARK: - View Body
  var body: some View {
    VStack {
      Text("An error has occurred!")
        .font(.title)
        .padding(.bottom)
      Text(errorWrapper.error.localizedDescription)
        .font(.headline)
      Text(errorWrapper.guidance)
        .font(.caption)
        .padding(.top)
      Spacer()
    }
    .padding()
    .background(.ultraThinMaterial)
    .cornerRadius(16)
  }
}

struct ErrorView_Previews: PreviewProvider {
  enum SampleError: Error {
    case errorRequired
  }
  static var wrapper: ErrorWrapper {
    ErrorWrapper(error: SampleError.errorRequired,
                 guidance: "You can safely ignore this error.")
  }
  static var previews: some View {
    ErrorView(errorWrapper: wrapper)
  }
}
