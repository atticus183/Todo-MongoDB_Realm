//
//  Todo-MongoDB_RealmApp.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/22/21.
//

import RealmSwift
import SwiftUI

let app: RealmSwift.App? = RealmSwift.App(id: Constants.REALM_ID)

@main
struct Todo_MongoDB_RealmApp: SwiftUI.App {

    @StateObject var realmService = DefaultRealmService()

    var body: some Scene {
        WindowGroup {
            if let app = app {
                if app.currentUser == nil {
                    LoginView().environmentObject(realmService)
                } else {
                    NavigationView {
                        TodoListView().environmentObject(realmService)
                    }
                }
            }
        }
    }
}
