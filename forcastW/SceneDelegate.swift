//
//  SceneDelegate.swift
//  forcastW
//
//  Created by Никита on 17.06.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	let coreDataManager = CoreDataStorage()
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)
		let view = LoginScreenAssembly().build()
		window.rootViewController = UINavigationController(rootViewController: view)
		self.window = window
		window.makeKeyAndVisible()
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		coreDataManager.saveContext()
	}
}
