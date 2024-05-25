//
//  QueryBar.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 6/21/22.
//

import SwiftUI

struct QueryBar: View {
  @ObservedObject var controller: Controller

  var body: some View {
    HStack {
      Divider()
      Button("Confirmations") {
        controller.queryType = .missingConfirmation
      }.buttonStyle(BlueButton())
      Divider()
      Button("Grid") {
        controller.displayedQsos[0].grid = "XXXX"
      }.buttonStyle(BlueButton())
      Divider()
      Button("Undefined") {

      }.buttonStyle(BlueButton())
      Divider()
      Button("Undefined") {

      }.buttonStyle(BlueButton())
      Divider()
    }
    .frame(height: 25)
  }
}

struct QueryBar_Previews: PreviewProvider {
    static var previews: some View {
      QueryBar(controller: Controller())
    }
}

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .padding(.leading).padding(.trailing)
            .background(Color(red: 0, green: 0.5, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
    }
}
