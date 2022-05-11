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
  
  let controller = Controller()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(controller)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
      return true
  }
}
