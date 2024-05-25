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
        Text("Grid")
          .frame(minWidth: 45, maxWidth: 45, alignment: .center)
        Divider()
        Text("Band")
          .frame(minWidth: 40, maxWidth: 40, alignment: .center)
        Divider()
        Text("Mode")
          .frame(minWidth: 75, maxWidth: 75, alignment: .center)
        Divider()
        Text("Status")
          .frame(minWidth: 200, maxWidth: 200, alignment: .center)
        Divider()
        Text("Date")
          .frame(minWidth: 160, maxWidth: .infinity, alignment: .center)
      }
      .foregroundColor(Color.blue)
      .font(.system(size: 14))
      .frame(height: 20)
      .border(.gray)
    }
  }
}

struct ListHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    ListHeaderView()
  }
}
