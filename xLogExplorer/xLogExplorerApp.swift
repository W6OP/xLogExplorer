//
//  xLogExplorerApp.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/8/22.
//

import SwiftUI

@main
struct xLogExplorerApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      ContentView()
        .fixedSize()
    }
    .windowResizability(.contentSize)
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
