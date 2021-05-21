//
//  SceneDelegate.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/16/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        if let _ = DefaultRealmService.app.currentUser {
            let navigationController = UINavigationController(rootViewController: TodoListVC())
            navigationController.navigationBar.prefersLargeTitles = true
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        } else {
            window?.rootViewController = LoginVC()
            window?.makeKeyAndVisible()
        }
    }
}

