//
//  SceneDelegate.swift
//  NewTest
//
//  Created by D. P. on 31.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let controller = ViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

