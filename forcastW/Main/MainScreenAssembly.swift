//
//  MainScreenAssembly.swift
//  forcastW
//
//  Created by Никита on 17.06.2021.
//

import UIKit

import Foundation

extension Notification.Name {
	static let updateNotification = Notification.Name("updateNotification")
}

final class MainScreenAssembly {
	func build(user: UserModel) -> UIViewController {
		let noteStorage = CoreDataStorage()
		let presenter = MainScreenPresenter(
											notesStorage: noteStorage,
											center: NotificationCenter.default,
											user: user)
		let controller = MainScreenViewController(presenter: presenter)
		return controller
	}
}
