//
//  TopRowView.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/17/22.
//

import SwiftUI

struct TopRowView: View {
  @ObservedObject var controller: Controller
  @ObservedObject var userSettings: UserSettings
  @State private var callSignToQuery = ""
  @State private var qrzUserId = ""
  @State private var qrzPassword = ""
  @State private var secured: Bool = true

  var body: some View {
    HStack {
      TextField("Call Sign", text: $callSignToQuery)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .frame(width: 100)
      .padding(2)

      Button("Query") {
        controller.queryDatabase(callSign: callSignToQuery.uppercased())
      }

      Divider()

      Button("QRZ Lookup") {
          controller.qrzLogon(callSignToQuery: callSignToQuery.uppercased())
      }

      TextField("QRZ Id", text: $userSettings.qrzUserId){
      }
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .frame(width: 75)
      .padding(2)

      SecureField("Password", text: $userSettings.qrzPassword){
      }
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .padding(2)

    }
  }
}

struct TopRowView_Previews: PreviewProvider {
  static var previews: some View {
    TopRowView(controller: Controller(), userSettings: UserSettings())
  }
}
