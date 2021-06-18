//
//  CoreDataStorage.swift
//  forcastW
//
//  Created by Никита on 17.06.2021.
//

import Foundation
import CoreData

final class CoreDataStorage {
	private enum Constants {
		static let containerName = "forcastW"
		static let entityName = "City"
	}
	
	lazy var container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: Constants.containerName)
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	lazy var context: NSManagedObjectContext = container.viewContext
	// MARK: - Core Data Saving support
	func saveContext() {
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}


protocol IUserStorage {
	func getUser(login: String, password: String) -> UserModel?
	func saveUser(user: UserModel, completion: @escaping () -> Void)
	func usersCount() -> Int
}
extension CoreDataStorage: IUserStorage {
	func getUser(login: String, password: String) -> UserModel? {
		let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.login)) = '\(login)' && \(#keyPath(User.password)) = '\(password)'")
		guard let object = try? self.container.viewContext.fetch(fetchRequest).first else { return nil }
		return UserModel(user: object)
	}

	func saveUser(user: UserModel, completion: @escaping () -> Void) {
		self.container.performBackgroundTask { context in
			let object = User(context: context)
			object.uid = user.uid
			object.login = user.login
			object.password = user.password
			try? context.save()
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { completion() })
		}
	}

	func usersCount() -> Int {
		let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
		return (try? self.container.viewContext.count(for: fetchRequest)) ?? 0
	}
}












protocol ICityStorage {
	func getNotes(for user: UserModel) -> [CityModel]
	func create(city: CityModel, completion: @escaping (NoteException?) -> Void)
	func loadEmployees(forCompany company: UserModel) -> [CityModel]
	func addNewEmployee(withEmployee city: CityModel, forCompany user: UserModel)
	func loadCompanies() -> [UserModel]
	//func update(note: CityModel, completion: @escaping (NoteException?) -> Void)
	//func remove(note: CityModel, completion: @escaping (NoteException?) -> Void)
	func deleteAll()
	func notesCount() -> Int
}

enum NoteException: Error {
	case saveFailed
	case updateFailed
	case removeFailed
	case loadFailed
}

extension CoreDataStorage: ICityStorage {
	
	func loadCompanies() -> [UserModel] {
		let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
		do {
			let data = try context.fetch(fetchRequest)
			return convertCompaniesToViewModel(companies: data)
		} catch let error {
			//self.errorPresenter?.presentError(error: .fetchError)
			print(error.localizedDescription)
		}
		return [UserModel]()
	}
	private func convertCompaniesToViewModel(companies: [User]) -> [UserModel] {
		var result = [UserModel]()
		for company in companies {
			if let newCompany = UserModel(user: company) {
				result.append(newCompany)
			}
		}
		return result
	}
	
	func deleteAll() {
		let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
		if let objects = try? container.viewContext.fetch(fetchRequest) {
			for object in objects {
				container.viewContext.delete(object)
			}
		}
		do {
			try container.viewContext.save()
		} catch let error {
			//self.errorPresenter?.presentError(error: .deleteAllError)
			print(error.localizedDescription)
		}
	}
	
	func loadEmployees(forCompany company: UserModel) -> [CityModel] {
		let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "ANY holder.uid = '\(company.uid)'")
		do {
			let data = try context.fetch(fetchRequest)
			return convertEmployeesToViewModel(employees: data)
		} catch let error {
			//self.errorPresenter?.presentError(error: .fetchError)
			print(error.localizedDescription)
		}
		print("[bad")
		return [CityModel]()
	}
	
	private func convertEmployeesToViewModel(employees: [City]) -> [CityModel] {
		var result = [CityModel]()
		for employee in employees {
			if let newEmployee = CityModel(city: employee) {
				result.append(newEmployee)
			}
		}
		return result
	}
	
	func getNotes(for user: UserModel)  -> [CityModel] {
		let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "ANY holder.uid = '\(user.uid)'")
		do {
		
			return try self.container.viewContext.fetch(fetchRequest).compactMap { CityModel(city: $0) }
		} catch {
			print(error.localizedDescription)
			
		}
		return [CityModel]()
	}

	func notesCount() -> Int {
		let fetchRequest = NSFetchRequest<City>(entityName: Constants.entityName)
		print("lol")
		return (try? self.container.viewContext.count(for: fetchRequest)) ?? 0
	}
	
	func addNewEmployee(withEmployee city: CityModel, forCompany user: UserModel) {
		let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.uid)) = '\(city.holder)'")
		guard let fetchedCompany = try? context.fetch(fetchRequest).first else { return }
		
		let object = City(context: context)
		object.uid = city.uid
		object.name = city.name
			  object.date = city.date
			  object.holder = fetchedCompany
		do {
			try context.save()
		} catch let error {
			//self.errorPresenter?.presentError(error: .saveError)
			print(error.localizedDescription)
		}
	}
	func create(city: CityModel, completion: @escaping (NoteException?) -> Void) {
		self.container.performBackgroundTask { context in
			do {
				print("check")
				let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
				fetchRequest.predicate = NSPredicate(format: "\(#keyPath(User.uid)) = '\(city.holder)'")
				guard let user = try context.fetch(fetchRequest).first else { return }
				let object = City(context: context)
				object.uid = city.uid
				object.name = city.name
				object.date = city.date
				object.holder = user
				if context.hasChanges {
					do {
						try context.save()
					} catch {
					  context.rollback()
						let nserror = error as NSError
						fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
					}
				}
				DispatchQueue.main.async { completion(nil) }
			} catch {
				DispatchQueue.main.async { completion(NoteException.saveFailed) }
			}
		}
	}
}
