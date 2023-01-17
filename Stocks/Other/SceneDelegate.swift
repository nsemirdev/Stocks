//
//  SceneDelegate.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        let rootVC = WatchListViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        
        window?.rootViewController = navVC
    }

}

