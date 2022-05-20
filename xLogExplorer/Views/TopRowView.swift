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
  @State private var callSignToQuery = ""
  @State private var qrzUserId = ""
  @State private var qrzPassword = ""
  @State private var secured: Bool = true
  @State private var title = "Password"

  var body: some View {
    HStack {
      TextField("Call Sign", text: $callSignToQuery)
      .disableAutocorrection(true)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .frame(width: 100)
      .padding(2)
      .onSubmit {  // <--- only on pressing the return key
        controller.queryDatabase(callSign: callSignToQuery.uppercased())
      }

      Divider()

//      Button("QRZ Lookup") {
//          controller.qrzLogon(callSignToQuery: callSignToQuery.uppercased())
//      }
//      .onSubmit {  // <--- only on pressing the return key
//        controller.qrzLogon(callSignToQuery: callSignToQuery.uppercased())
//      }

      TextField("QRZ Id", text: $userSettings.qrzUserId){
      }
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .frame(width: 75)
      .padding(2)

//      SecureField("Password", text: $userSettings.qrzPassword){
//      }
//      .textFieldStyle(RoundedBorderTextFieldStyle())
//      .padding(2)

        HStack {
            if secured {
                SecureField(title, text: $userSettings.qrzPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 250)
            } else {
                TextField(title, text: $userSettings.qrzPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
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
