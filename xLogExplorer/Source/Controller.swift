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

@MainActor
class Controller: ObservableObject {

  @Published var statusMessages = [StatusMessage]()
  @Published var displayedQsos = [QSO]()
  @Published var qrzData = [String: String]()
  @Published var queryType: QueryType = .unConfirmed {
    didSet {
      queryDatabase(queryType: queryType)
    }
  }

  let databaseManager = DatabaseManager()

  let logger = Logger(subsystem: "com.w6op.xLogExplorer", category: "Controller")
  // Call Parser
  let callParser = PrefixFileParser()
  var callLookup = CallLookup()
  var hitsCache = HitCache()
  var missingGridStatus = false

  // persist the call sign
  var callSignToQuery = ""

  var doHaveSessionKey = false

  init() {
    callParserCallback()
    setupSessionCallback()
  }

  func queryDatabase(queryLiteral: String) {
    // catch later
    print("Current thread 2: \(Thread.current.threadName)")

    do {
      qrzData.removeAll()

      guard !queryLiteral.isEmpty else {
        return
      }

      displayedQsos = try databaseManager.openDatabase(callSign: queryLiteral)
      qrzLogon(callSignToQuery: queryLiteral)
    }
    catch {
      print("query failed")
    }
  }

  func queryDatabase(queryType: QueryType) {
    do {
      displayedQsos = try databaseManager.openDatabase(queryType: queryType)
    }
    catch {
      print(error.localizedDescription)
    }
  }

  // MARK: - CallParser Operations

  // MARK: - Lookup call with CallParser - Callback

  /// Lookup a spot using the CallParser component.
  /// - Parameter spot: ClusterSpot
  func lookupCall() throws {
    let spotInformation = (spotId: 123456789, sequence: 1)

    Task { @MainActor in
        qrzData.removeAll()
      }

    self.callLookup.lookupCall(call: callSignToQuery,
                               spotInformation: spotInformation)
  }

  /// Callback when CallLookup finds a Hit.
  func callParserCallback() {
    callLookup.didUpdate = { [self] hitList in
      if !hitList!.isEmpty {
        let hit = hitList![0]

        Task { @MainActor in
          qrzData["grid"] = hit.grid
            qrzData["city"] = hit.city
            qrzData["county"] = hit.county
            qrzData["state"] = hit.province
            qrzData["country"] = hit.country
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

      updateStatus(statusMessage: statusMessage)
    }
  }

  func updateStatus(statusMessage: StatusMessage) {

    Task { @MainActor in
      statusMessages.append(statusMessage)
      qrzData["city"] = statusMessage.message
    }
  }

} // end class


/*
 "SELECT pk, band_rx, mode, grid, qsl_received, datetime(qso_start,\'unixepoch\') FROM qso_table_v008 WHERE band_rx LIKE \'6%\' AND qsl_received == \'\' ORDER BY grid"
 */
