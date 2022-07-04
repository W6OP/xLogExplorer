//
//  Utility.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/10/22.
//

import Foundation
import CallParser

enum QueryType {
  case missingConfirmation
  case missingGrid
}

struct QSO: Identifiable, Hashable {

  var id = 0
  var band = ""
  var mode = ""
  var grid = ""
  var qslStatus = ""
  var qslDate = ""
  var lotw = false

  init() {
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

  @Published var qrzUserId: String {
    didSet {
      UserDefaults.standard.set(qrzUserId, forKey: "qrzUserId")
    }
  }

  @Published var qrzPassword: String {
    didSet {
      UserDefaults.standard.set(qrzPassword, forKey: "qrzPassword")
    }
  }

  init() {
    databaseLocation = UserDefaults.standard.string(forKey: "databaseLocation") ?? ""
    qrzUserId = UserDefaults.standard.string(forKey: "qrzUserId") ?? ""
    qrzPassword = UserDefaults.standard.string(forKey: "qrzPassword") ?? ""
  }
}

// MARK: - Actors
/// Temporary storage of Hits to match up with temporarily
/// stored ClusterSpots.
actor HitCache {
  var hits: [Int: [Hit]] = [:]

  /// Add a Hit to the cache.
  /// - Parameters:
  ///   - hitId: Int
  ///   - hit: Hit
  func addHit(hitId: Int, hit: Hit) {
    if hits[hitId] != nil {
        hits[hitId]?.append(hit)
    } else {
      var newHits: [Hit] = []
      newHits.append(hit)
      hits.updateValue(newHits, forKey: hitId)
    }
  }

  /// Remove 2 Hits.
  /// - Parameter spotId: Int
  func removeHits(spotId: Int) -> [Hit] {
    if hits[spotId] != nil && hits[spotId]!.count > 1 {
      return hits.removeValue(forKey: spotId) ?? []
    }
    return []
  }

  /// Remove all Hits.
  func clear() {
    hits.removeAll()
  }

  /// Return the number of Hits.
  /// - Returns: Int
  func getCount() -> Int {
    return hits.count
  }

  /// Return the number of Hits.
  /// - Returns: Int
  func getCount(spotId: Int) -> Int {
    return hits[spotId]?.count ?? 0
  }
}
