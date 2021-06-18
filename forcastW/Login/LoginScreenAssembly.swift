//
//  LoginScreenAssembly.swift
//  forcastW
//
//  Created by Никита on 17.06.2021.
//

import UIKit

final class LoginScreenAssembly {
	func build() -> UIViewController {
		let userStorage = CoreDataStorage()
		let router = LoginScreenRouter()
		let presenter = LoginScreenPresenter(router: router, userStorage: userStorage)
		
		let controller = LoginScreenViewController(presenter: presenter)
		router.controller = controller
		
		return controller
		
	}
}
