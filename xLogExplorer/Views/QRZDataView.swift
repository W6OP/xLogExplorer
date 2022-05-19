//
//  QRZDataView.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/17/22.
//

import SwiftUI

struct QRZDataView: View {
  @ObservedObject var controller: Controller

    var body: some View {
      HStack {
        Text(controller.qrzData["city"] ?? "")
          .padding(2)
        Text(controller.qrzData["county"] ?? "")
          .padding(2)
        Text(controller.qrzData["state"] ?? "")
          .padding(2)
        Text(controller.qrzData["country"] ?? "")
          .padding(2)
        Spacer()
      }
      .padding(2)
    }
}

struct QRZDataView_Previews: PreviewProvider {
    static var previews: some View {
        QRZDataView(controller: Controller())
    }
}
