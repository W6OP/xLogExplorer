//
//  Controller.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/10/22.
//

import Foundation
import OSLog
import CallParser

/// Status message definition
struct StatusMessage: Identifiable, Hashable {
  var id = UUID()
  var message = ""
}

class Controller: ObservableObject {

  @Published var statusMessages = [StatusMessage]()
  @Published var displayedQsos = [QSO]()
  @Published var qrzData = [String: String]()

  let databaseManager = DatabaseManager()

  let logger = Logger(subsystem: "com.w6op.xLogExplorer", category: "Controller")
  // Call Parser
  let callParser = PrefixFileParser()
  var callLookup = CallLookup()
  var hitsCache = HitCache()

  // persist the call sign
  var callSignToQuery = ""

  var doHaveSessionKey = false

  init() {
    callParserCallback()
    setupSessionCallback()
  }

  func queryDatabase(callSign: String) {
    // catch later
    do {
      Task {
        await MainActor.run {
          qrzData.removeAll()
        }
      }
      displayedQsos = try databaseManager.openDatabase(callSign: callSign)
      qrzLogon(callSignToQuery: callSign)
    }
    catch {
      print("query failed")
    }
  }

  // MARK: - CallParser Operations

  // MARK: - Lookup call with CallParser - Callback

  /// Lookup a spot using the CallParser component.
  /// - Parameter spot: ClusterSpot
  func lookupCall() throws {
    let spotInformation = (spotId: 123456789, sequence: 1)

    Task {
      await MainActor.run {
        qrzData.removeAll()
      }
    }

    self.callLookup.lookupCall(call: callSignToQuery,
                               spotInformation: spotInformation)
  }

  /// Callback when CallLookup finds a Hit.
  func callParserCallback() {
    callLookup.didUpdate = { [self] hitList in
      if !hitList!.isEmpty {
        let hit = hitList![0]
        print(hit)
        Task {
          await MainActor.run {
            qrzData["city"] = hit.city
            qrzData["county"] = hit.county
            qrzData["state"] = hit.province
            qrzData["country"] = hit.country
          }
        }
      }
    }
  }

  // MARK: - QRZ Logon

  // TODO: feedback to user logon was successful
  /// Logon to QRZ.com
  /// - Parameters:
  ///   - userId: String
  ///   - password: String
  func qrzLogon(callSignToQuery: String) {

    self.callSignToQuery = callSignToQuery

    guard let userId = UserDefaults.standard.string(forKey: "qrzUserId") else {
      return
      //throw DatabaseError.invalidPath
    }

    guard let password = UserDefaults.standard.string(forKey: "qrzPassword") else {
      return
      //throw DatabaseError.invalidPath
    }

    if !doHaveSessionKey {
      callLookup.logonToQrz(userId: userId, password: password)
    } else {
      try! lookupCall()
    }
  }

  /// Callback from the Call Parser for QRZ logon success/failure.
  func setupSessionCallback() {
    var statusMessage = StatusMessage()

    callLookup.didGetSessionKey = { [self] arg0 in
      let session: (state: Bool, message: String) = arg0!
      if !session.state {
        statusMessage.message = "QRZ logon failed: \(session.message)"
        doHaveSessionKey = false
      } else {
        statusMessage.message = "QRZ logon successful"
        doHaveSessionKey = true
        try! lookupCall()
      }

      let status = statusMessage
      Task {
        await MainActor.run {
          self.statusMessages.append(status)
          qrzData["city"] = status.message
          //print(status.message)
        }
      }
    }
  }


} // end class
