//
//  LoginScreenRouter.swift
//  forcastW
//
//  Created by Никита on 17.06.2021.
//

import Foundation

import UIKit

protocol ILoginScreenRouter: AnyObject {
	func openMainScreen(user: UserModel)
}

final class LoginScreenRouter: ILoginScreenRouter {
	weak var controller: UIViewController?

	func openMainScreen(user: UserModel) {
		guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
		let viewController = MainScreenAssembly().build(user: user)
		let navigationVC = UINavigationController(rootViewController: viewController)
		window.rootViewController = navigationVC
		window.makeKeyAndVisible()
		window.overrideUserInterfaceStyle = .light
		let options: UIView.AnimationOptions = .transitionCrossDissolve
		let duration: TimeInterval = 0.3
		UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
	}
}
