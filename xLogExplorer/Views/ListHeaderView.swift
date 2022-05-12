//
//  ListHeaderView.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/11/22.
//

import SwiftUI

struct ListHeaderView: View {
  var body: some View {

    VStack {
      HStack {
        Text("Band")
          .frame(minWidth: 45, maxWidth: 45, alignment: .center)
          .border(width: 1, edges: [.trailing], color: .gray)
        Text("Mode")
          .frame(minWidth: 40, maxWidth: 40, alignment: .center)
          .border(width: 1, edges: [.trailing], color: .gray)
        Text("Grid")
          .frame(minWidth: 75, maxWidth: 75, alignment: .center)
          .border(width: 1, edges: [.trailing], color: .gray)
        Text("Status")
          .frame(minWidth: 200, maxWidth: 200, alignment: .center)
          .border(width: 1, edges: [.trailing], color: .gray)
        Text("Date")
          .frame(minWidth: 160, maxWidth: .infinity, alignment: .leading)
          //.border(width: 1, edges: [.trailing], color: .gray)
      }
      //.border(Color.gray)
      .foregroundColor(Color.blue)
      .font(.system(size: 14))
    }
    //.frame(width: 550)
    //.border(Color.red)
  }
}

struct ListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ListHeaderView()
    }
}
