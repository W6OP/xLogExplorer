//
//  DatabaseManager.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/10/22.
//

import Foundation
import SQLite3

enum DatabaseError: Error {
  case unableToOpen
  case databaseMissing
  case invalidPath
  case emptyPath
  case readError
}


/// Query a database and return an array of QSOs
class DatabaseManager {

  init() {

  }

  /// Open the SQLite database
  /// - Parameter callSign: String
  /// - Returns: [QSO]
  func openDatabase(callSign: String) throws  -> [QSO] {
    var db: OpaquePointer?

    guard let databaseLocation = UserDefaults.standard.string(forKey: "databaseLocation") else {
      throw DatabaseError.invalidPath
    }

    if databaseLocation.isEmpty {
      throw DatabaseError.emptyPath
    }

    let fileURL = URL(string: databaseLocation)

    //opening the database
    if sqlite3_open(fileURL?.path, &db) != SQLITE_OK {
      let errmsg = String(cString: sqlite3_errmsg(db))
      print("error opening database: \(errmsg)")
      throw DatabaseError.unableToOpen
    }

    let qsos = try queryDatabase(callSign: callSign, db: db!)

    return qsos
  }

  /// Queries the database
  /// - Parameters:
  ///   - callSign: String
  ///   - db: Opaque Pointer
  /// - Returns: [QSO]
  func queryDatabase(callSign: String, db: OpaquePointer?) throws ->[QSO] {
    var qsos = [QSO]()
    let queryString = "SELECT pk, band_rx, mode, grid, qsl_received, datetime(qso_start,'unixepoch') FROM qso_table_v007 WHERE call == '\(callSign)' ORDER BY mode"

    var db = db
    if sqlite3_prepare(db, queryString, -1, &db, nil) != SQLITE_OK{
      let errmsg = String(cString: sqlite3_errmsg(db)!)
      print("error preparing query: \(errmsg)")
      sqlite3_finalize(db)
      throw DatabaseError.readError
    }

    while(sqlite3_step(db) == SQLITE_ROW){
      var qso = QSO()
      qso.id = Int(sqlite3_column_int(db, 0))
      qso.band = String(cString: sqlite3_column_text(db, 1))
      qso.mode = String(cString: sqlite3_column_text(db, 2))
      if sqlite3_column_text(db, 3) != nil {
        qso.grid = String(cString: sqlite3_column_text(db, 3))
      }
      if sqlite3_column_text(db, 4) != nil {
        qso.qslStatus = String(cString: sqlite3_column_text(db, 4))
      }
      qso.qslDate = String(cString: sqlite3_column_text(db, 5))

      qsos.append(qso)
    }

    sqlite3_finalize(db)

    return qsos
  }

  // https://shareup.app/blog/building-a-lightweight-sqlite-wrapper-in-swift/
} // end class

