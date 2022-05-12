//
//  Controller.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/10/22.
//

import Foundation

class Controller: ObservableObject {

  let databaseManager = DatabaseManager()

@Published var displayedQsos = [QSO]()

  init() {
   
  }

  func queryDatabase(callSign: String) {
    // catch later
    do {
    displayedQsos = try databaseManager.openDatabase(callSign: callSign)
    }
    catch {
      print("query failed")
    }
  }

} // end class
