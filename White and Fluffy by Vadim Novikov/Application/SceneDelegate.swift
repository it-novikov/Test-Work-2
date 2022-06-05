//
//  SceneDelegate.swift
//  White and Fluffy by Vadim Novikov
//
//  Created by Vadim Novikov on 05.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
    }

}

