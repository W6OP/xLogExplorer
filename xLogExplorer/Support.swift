//
//  Utility.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/10/22.
//

import Foundation

struct QSO: Identifiable, Hashable {

  var id = 0
  var band = ""
  var mode = ""
  var grid = ""
  var qslStatus = ""
  var qslDate = ""
  var lotw = false

  init() {
    //id = self.id.hashValue
  }
}

// MARK: - User Defaults

// https://www.simpleswiftguide.com/how-to-use-userdefaults-in-swiftui/
class UserSettings: ObservableObject {

  @Published var databaseLocation: String {
    didSet {
      UserDefaults.standard.set(databaseLocation, forKey: "databaseLocation")
    }
  }

  init() {
    databaseLocation = UserDefaults.standard.string(forKey: "databaseLocation") ?? ""
  }
}
