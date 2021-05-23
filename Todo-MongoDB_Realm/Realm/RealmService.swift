//
//  RealmService.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/16/21.
//

import Combine
import RealmSwift

protocol RealmService {

    /// The Realm App to retrieve the currentUser, configuration, etc.
    static var app: App { get }

    /// Realm App ID retrieved from MongoDBRealm dashboard
    static var appID: String { get }

    func signUp(with email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func login(with email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
}

class DefaultRealmService: RealmService, ObservableObject {
//    @Published var isSignInSuccessful: Bool = false

    static var app: App = App(id: appID)

    // If the build is failing, add the App ID here as a string.  The Constants file is not tracked by Git.
    static var appID: String = Constants.REALM_ID

    /// Partition key to use for all persisted objects.
    /// This approach is suitable if you want to restrict ALL data to a specific user.
    static var partitionKeyToAssign: String {
        "user=\(userID)"
    }

    static var userID: String {
        app.currentUser!.id
    }

    static var configuration: Realm.Configuration {
        app.currentUser!.configuration(partitionValue: partitionKeyToAssign)
    }

    static func getRealm() -> Realm {
        try! Realm(configuration: DefaultRealmService.configuration)
    }

    func signUp(with email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DefaultRealmService.app.emailPasswordAuth.registerUser(email: email, password: password) { error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            self.login(with: email, password: password) { result in
                switch result {
                case .success():
                    completion(.success(()))
                case .failure(let error):
                    print("ERROR LOGGING IN AFTER REGISTERING:\(error.localizedDescription)")
                }
            }
        }
    }

    func login(with email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let credentials = Credentials.emailPassword(email: email, password: password)
        DefaultRealmService.app.login(credentials: credentials) { result in
            switch result {
            case .success(let user):
                let configuration = user.configuration(partitionValue: "user=\(user.id)")
                Realm.asyncOpen(configuration: configuration) { result in
                    switch result {
                    case .success(let realm):
                        let users = realm.objects(User.self)
                        if users.count == 0 {
                            try! realm.write {
                                let newUser = User(user: email)
                                realm.add(newUser)
                            }
                        }
                        completion(.success(()))
                    case .failure(let error):
                        print("ERROR OPENING REALM: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("LOGIN ERROR: \(error.localizedDescription)")
            }
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        if let user = DefaultRealmService.app.currentUser {
            user.logOut(completion: { (error) in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }

                completion(.success(()))
            })
        }
    }
}
