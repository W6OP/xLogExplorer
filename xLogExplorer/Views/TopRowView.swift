//
//  TopRowView.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 5/17/22.
//

import SwiftUI

struct TopRowView: View {
  @ObservedObject var controller: Controller
  @ObservedObject var userSettings: UserSettings
  @State private var queryTerm = ""
  @State private var qrzUserId = ""
  @State private var qrzPassword = ""
  @State private var secured: Bool = true
  @State private var title = "Password"

  var body: some View {
    HStack {
      TextField("Call Sign", text: $queryTerm)
        .disableAutocorrection(true)
        .textFieldStyle(.roundedBorder)
        //.textCase(.uppercase)
        .frame(width: 100)
        .padding(2)
        .onSubmit {  // <--- only on pressing the return key
          if queryTerm.count > 10 {
            queryTerm = String(queryTerm.prefix(10))
          }
          controller.queryDatabase(queryLiteral: queryTerm.uppercased())
        }
        .onChange(of: queryTerm) { tag in
          queryTerm = queryTerm.uppercased()
        }

      Divider()

//      CheckBoxViewExact(controller: controller)
//      Divider()

      TextField("QRZ Id", text: $userSettings.qrzUserId){
      }
      .disableAutocorrection(true)
      .textFieldStyle(.roundedBorder)
      //.textCase(.uppercase)
      .frame(width: 75)
      .padding(2)
      .onChange(of: qrzUserId) { tag in
        qrzUserId = qrzUserId.uppercased()
      }

      HStack {
        if secured {
          SecureField(title, text: $userSettings.qrzPassword)
            .textFieldStyle(.roundedBorder)
            .frame(width: 250)
        } else {
          TextField(title, text: $userSettings.qrzPassword)
            .textFieldStyle(.roundedBorder)
            .frame(width: 250)
        }
        Image(systemName: self.secured ? "eye.slash" : "eye")
          .accentColor(.gray)
          .onTapGesture {
            secured.toggle()
          }
      }
      .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1).foregroundColor(Color.white))

      Spacer()
    }
    .frame(minHeight: 25, maxHeight: 25)
  }
}

struct TopRowView_Previews: PreviewProvider {
  static var previews: some View {
    TopRowView(controller: Controller(), userSettings: UserSettings())
  }
}

/// Creates secure field with eye to show/hide password
/// https://stackoverflow.com/questions/63095851/show-hide-password-how-can-i-add-this-feature
struct SecureInputView: View {

  @Binding private var text: String
  @State private var isSecured: Bool = true
  private var title: String

  init(_ title: String, text: Binding<String>) {
    self.title = title
    self._text = text
  }

  var body: some View {
    ZStack(alignment: .trailing) {
      Group {
        if isSecured {
          SecureField(title, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(2)
        } else {
          TextField(title, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(2)
        }
      }.padding(.trailing, 32)

      Button(action: {
        isSecured.toggle()
      }) {
        Image(systemName: self.isSecured ? "eye.slash" : "eye")
          .accentColor(.gray)
      }
    }
  }
}

// MARK: - Checkbox

//struct CheckBoxView: View {
//    var controller: Controller
//    @State private var digiOnly = false
//
//    var body: some View {
//        Image(systemName: digiOnly ? "checkmark.square.fill" : "square")
//        .foregroundColor(digiOnly ? Color(.black) : Color.black)
//            .onTapGesture {
//                self.digiOnly.toggle()
//                controller.missingGridStatus = digiOnly
//            }
//      Text("FT4/FT8 Only")
//    }
//}
//
//struct CheckBoxViewExact: View {
//    var controller: Controller
//    @State private var exactMatch = false
//
//    var body: some View {
//        Image(systemName: exactMatch ? "checkmark.square.fill" : "square")
//        .foregroundColor(exactMatch ? Color(.red) : Color.black)
//            .onTapGesture {
//                self.exactMatch.toggle()
//              controller.missingGridStatus = exactMatch
//            }
//      Text("Not Confirmed")
//    }
//}
