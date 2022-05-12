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
  @State private var highlighted: Int?

    var body: some View {
      ScrollView {
        VStack(spacing: 1) {
          ForEach(controller.displayedQsos, id: \.self) { qso in
            QSORowView(qso: qso)
              .background(qso.id == highlighted ? Color(red: 141, green: 213, blue: 240) : Color(red: 209 / 255, green: 215 / 255, blue: 226 / 255))
          }
        }
        .background(currentMode == .dark ?  Color(red: 0.2, green: 0.6, blue: 0.8) : Color(red: 209 / 255, green: 215 / 255, blue: 226 / 255))
      }
    }

}

// MARK: - Spot Row

struct QSORowView: View {
  var qso: QSO

  var body: some View {
    VStack{
      HStack {
        Text(qso.band)
          .frame(minWidth: 40, maxWidth: 40, alignment: .leading)
          .padding(.leading, 5)
          .border(width: 1, edges: [.trailing], color: .gray)
        Text(qso.mode)
          .frame(minWidth: 40, maxWidth: 40, alignment: .leading)
          .border(width: 1, edges: [.trailing], color: .gray)
        Text(qso.grid)
          .frame(minWidth: 75, maxWidth: 75, alignment: .leading)
          .border(width: 1, edges: [.trailing], color: .gray)
        Text(qso.qslStatus)
          .frame(minWidth: 50, maxWidth: 200, alignment: .leading)
          .border(width: 1, edges: [.trailing], color: .gray)
        Text(qso.qslDate)
          .frame(minWidth: 150, maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 5)
          .padding(.trailing, 5)
          .border(width: 1, edges: [.trailing], color: .gray)
      }
      .frame(maxHeight: 17)
    }
    .frame(minWidth: 300, minHeight: 18)
    .border(Color.gray)
  }
}

struct ListDisplayView_Previews: PreviewProvider {
    static var previews: some View {
      ListDisplayView(controller: Controller())
    }
}

extension View {
  func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
    overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
  }
}

struct EdgeBorder: Shape {

  var width: CGFloat
  var edges: [Edge]

  func path(in rect: CGRect) -> Path {
    var path = Path()
    for edge in edges {
      var xCoordinate: CGFloat {
        switch edge {
        case .top, .bottom, .leading: return rect.minX
        case .trailing: return rect.maxX - width
        }
      }

      var yCoordinate: CGFloat {
        switch edge {
        case .top, .leading, .trailing: return rect.minY
        case .bottom: return rect.maxY - width
        }
      }

      var width: CGFloat {
        switch edge {
        case .top, .bottom: return rect.width
        case .leading, .trailing: return self.width
        }
      }

      var height: CGFloat {
        switch edge {
        case .top, .bottom: return self.width
        case .leading, .trailing: return rect.height
        }
      }
      path.addPath(Path(CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)))
    }
    return path
  }
}
