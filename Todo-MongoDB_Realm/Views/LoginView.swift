//
//  LoginView.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/21/21.
//

import RealmSwift
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false
    @State private var isSignInSuccessful = false

    @State private var realmService = DefaultRealmService()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding(.leading, 20)
                    .padding(.top, 100)

                TextField("Password", text: $password)
                    .textContentType(.password)
                    .padding(.leading, 20)
                    .padding(.top, 20)

                HStack {
                    Button(action: {
                        isSignUp.toggle()
                    }, label: {
                        Image(systemName: isSignUp ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .leading)
                    })
                    .padding(.leading, 20)
                    Text("Sign up?")
                    Spacer()
                }.padding(.top, 20)

//                Button("Login") {
//                    if isSignUp {
//                        realmService.signUp(with: email, password: password) { result in
//                            switch result {
//                            case .success():
//                                isSignInSuccessful = true
//
//                            case .failure(let error):
//                                print("Error signing up: \(error.localizedDescription)")
//                            }
//                        }
//                    } else {
//                        realmService.login(with: email, password: password) { result in
//                            switch result {
//                            case .success():
//                                isSignInSuccessful = true
//                            case .failure(let error):
//                                print("Error signing in: \(error.localizedDescription)")
//                            }
//                        }
//                    }
//                }
//                .frame(width: 200, height: 50)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)

                NavigationLink(
                    destination: TodoListView(),
//                    isActive: $isSignInSuccessful,
                    isActive: $isSignInSuccessful,
                    label: {
                        Button(action: {
                            if isSignUp {
                                realmService.signUp(with: email, password: password) { result in
                                    switch result {
                                    case .success():
                                        isSignInSuccessful = true
                                        
                                    case .failure(let error):
                                        print("Error signing up: \(error.localizedDescription)")
                                    }
                                }
                            } else {
                                realmService.login(with: email, password: password) { result in
                                    switch result {
                                    case .success():
                                        isSignInSuccessful = true
                                    case .failure(let error):
                                        print("Error signing in: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }, label: {
                            Text("Login")
                                .frame(width: 200, height: 50, alignment: .center)
                                .font(.headline)
                                .foregroundColor(.white)
                                .background(Color.pink)
                                .cornerRadius(10)
                        })
                    })

                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
