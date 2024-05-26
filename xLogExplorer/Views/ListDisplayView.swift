//
//  ListDisplayView.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/10/22.
//

import SwiftUI

struct ListDisplayView: View {
  @ObservedObject var controller: Controller
  @Environment(\.colorScheme) var currentMode

    var body: some View {
      ScrollView {
        LazyVStack(spacing: 1) {
          ForEach(controller.displayedQsos) { qso in
            QSORowView(qso: qso)
          }
          .listStyle(.inset(alternatesRowBackgrounds: true))
        }
        .background(currentMode == .dark ?  Color(red: 0.2, green: 0.6, blue: 0.8) : Color(red: 209 / 255, green: 215 / 255, blue: 226 / 255))
      }
    }
}

// MARK: - QSO Row

struct QSORowView: View {
  var qso: QSO

  var body: some View {
    VStack{
      HStack {
        Text(qso.grid)
          .frame(minWidth: 75, maxWidth: 75, alignment: .leading)
        Divider()
        Text(qso.band)
          .frame(minWidth: 40, maxWidth: 40, alignment: .center)
          .padding(.leading, 5)
        Divider()
        Text(qso.mode)
          .frame(minWidth: 40, maxWidth: 40, alignment: .leading)
        Divider()
        if qso.call != "" {
          Text(qso.call)
            .frame(minWidth: 200, maxWidth: 200, alignment: .leading)
        } else {
          Text(qso.qslStatus)
            .frame(minWidth: 200, maxWidth: 200, alignment: .leading)
        }
        Divider()
        Text(qso.qslDate)
          .frame(minWidth: 150, maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 5)
          .padding(.trailing, 5)
      }
      .frame(maxHeight: 20)
    }
    Divider()
  }
}

struct ListDisplayView_Previews: PreviewProvider {
    static var previews: some View {
      ListDisplayView(controller: Controller())
    }
}
