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

//  func openDatabase() -> OpaquePointer?
//      {
//          let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//              .appendingPathComponent(dbPath)
//          var db: OpaquePointer? = nil
//          if sqlite3_open(fileURL.path, &db) != SQLITE_OK
//          {
//              print("error opening database")
//              return nil
//          }
//          else
//          {
//              print("Successfully opened connection to database at \(dbPath)")
//              return db
//          }
//      }

  /// Open the SQLite database
  /// - Parameter callSign: String
  /// - Returns: [QSO]
  func openDatabase(callSign: String) throws  -> [QSO] {
    var db: OpaquePointer?
    var qsos: [QSO] = []

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

    qsos = try queryDatabase(queryLiteral: callSign, db: db!)

    return qsos
  }

  /// Queries the database
  /// - Parameters:
  ///   - callSign: call sign to queru=y
  ///   - db: Opaque Pointer
  /// - Returns: [QSO]
  func queryDatabase(queryLiteral: String, db: OpaquePointer?) throws ->[QSO] {
    var qsos = [QSO]()
    var queryString = "SELECT pk, band_rx, mode, grid, qsl_received, datetime(qso_start,'unixepoch') FROM qso_table_v008 WHERE call == '\(queryLiteral)' ORDER BY mode"

    let regex = NSRegularExpression("[A-Z][A-Z][0-9][0-9]")
    if regex.matches(queryLiteral) { // Query by grid.
      queryString = "SELECT pk, band_rx, mode, grid, qsl_received, datetime(qso_start,'unixepoch') FROM qso_table_v008 WHERE band_rx LIKE '6%' AND grid LIKE '\(queryLiteral)%' ORDER BY mode"
    }

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

  // MARK: - Additional Queries

  /// Open the SQLite database
  /// - Parameter callSign: String
  /// - Returns: [QSO]
  func openDatabase(queryType: QueryType) throws  -> [QSO] {
    var db: OpaquePointer?
    var qsos: [QSO] = []

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

    if queryType == .unConfirmed {
      qsos = try queryDatabase(queryType: queryType, db: db!, confirmed: false)
    } else   {
      qsos = try queryDatabase(queryType: queryType, db: db!, confirmed: true)
    }


    return qsos
  }

  // NOTE: - If queries fail check to see if the database version changed i.e. qso_table_v008 t0 qso_table_v009
  
  /// Queries the database
  /// - Parameters:
  ///   - callSign: call sign to queru=y
  ///   - db: Opaque Pointer
  /// - Returns: [QSO]
  func queryDatabase(queryType: QueryType, db: OpaquePointer?, confirmed: Bool) throws -> [QSO] {
    var qsos = [QSO]()
    var queryString = "SELECT pk, band_rx, mode, grid, qsl_received, datetime(qso_start,'unixepoch') FROM qso_table_v008 WHERE band_rx LIKE '6%' AND qsl_received == '' ORDER BY grid"

    if confirmed {
      queryString = "SELECT pk, band_rx, mode, grid, qsl_received, datetime(qso_start,'unixepoch') FROM qso_table_v008 WHERE band_rx LIKE '6%' AND qsl_received != '' ORDER BY grid"
    }

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

// MARK: Extensions for Regex

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
