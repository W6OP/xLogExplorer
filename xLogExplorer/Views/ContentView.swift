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
  @EnvironmentObject var controller: Controller
  @ObservedObject var userSettings = UserSettings()
  @State private var callSignToQuery = ""
  @State private var databaseLocation = ""
 // @State private var showDatabasePicker = false

  var body: some View {
    VStack(spacing: 1) {
      // MARK: - Call Sign Query
      HStack {
        TextField("Call Sign", text: $callSignToQuery)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(width: 100)
        .padding(2)

        Button("Query") {
          controller.queryDatabase(callSign: callSignToQuery.uppercased())
        }

        Spacer()
      }
      //.border(Color.gray)
      Divider()
      // MARK: - ListHeaderView
      ListHeaderView()

      // MARK: - ListView
      HStack {
        ListDisplayView(controller: controller)
      }
      .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 200)
      .border(Color.gray)

      Divider()

      // MARK: - Database Selection
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
      //.frame(width: 580)
      //.border(Color.gray)
    } // end outer VStack
    .frame(width: 580)
  } // end body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(Controller())
    }
}
