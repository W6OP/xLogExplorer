//
//  Controller.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/10/22.
//

import Foundation

class Controller: ObservableObject {

  let databaseManager = DatabaseManager()
  var databaseLocation = UserDefaults.standard.string(forKey: "databaseLocation") ?? ""

@Published var displayedQsos = [QSO]()

  init() {

  }

  func queryDatabase(callSign: String) {
    print("\(callSign)")
    // catch later
    displayedQsos = try! databaseManager.openDatabase(callSign: callSign)
  }

} // end class
