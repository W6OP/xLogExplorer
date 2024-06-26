//
//  ContentView.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/8/22.
//
// App to read the MacLoggerDX database and list grids and call signs so when
// I am using WSJT-X I can quickly see if I have worked that person on 6 meters
// using FT8 so I don't work them twice.
//
// Need an input box for the call sign.
// ListView for results.
//
// Preferences or selection box to locate the DataBase.

import SwiftUI

struct ContentView: View {
  @StateObject var controller = Controller()
  @StateObject var userSettings = UserSettings()

  @State private var databaseLocation = ""

  var body: some View {
    VStack(spacing: 1) {
      // MARK: - Call Sign Query


      TopRowView(controller: controller,userSettings: userSettings)
        .border(.blue)
      


      //Divider()

      // MARK: - ListHeaderView
      ListHeaderView()
      //Divider()

      // MARK: - ListView
      HStack {
        ListDisplayView(controller: controller)
      }
      .frame(maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
      .border(.green)

      QRZDataView(controller: controller)
      //Divider()

      QueryBar(controller: controller)
      // MARK: - Database Selection
     // Divider()

      HStack {
        TextField("Select Database", text: $userSettings.databaseLocation){
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(2)

        Button("Browse") {
          let panel = NSOpenPanel()
          panel.allowsMultipleSelection = false
          panel.canChooseDirectories = false
          if panel.runModal() == .OK {
            userSettings.databaseLocation = panel.url?.absoluteString ?? ""
          }
        }
        Spacer()
      }
    } // end outer VStack
    .frame(width: 600, height: 500, alignment: .topLeading)
    .border(.red)
    .padding(25)
  } // end body
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
      ContentView(controller: Controller())
        //.environmentObject(Controller())
    }
}

