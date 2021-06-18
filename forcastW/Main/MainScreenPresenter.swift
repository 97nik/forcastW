//
//  MainScreenPresenter.swift
//  forcastW
//
//  Created by Никита on 17.06.2021.
//

import Foundation

struct Model {
let id: UUID
let name: String

}



final class MainScreenPresenter {
	private weak var adapter: MainScreenTableAdapter?
	private weak var controller: MainScreenViewController?
//	private let router: IMainScreenRouter
	private let notesStorage: CoreDataStorage
	private let center: NotificationCenter
	//private let configurationReader: IConfigurationReader
	//private let backupManager: IBackupManager
	private let user: UserModel
	private var noteData: CityModel?
	private var notes: [CityModel] = []
	
	
	private var model: [CityModel]?
	
	
	private var city: [String] = []
	//private var networkService = NetworkService()
	//private var mainScreenCellPresenter = [MainScreenCellPresenter]()
	init(notesStorage: CoreDataStorage, center: NotificationCenter, user: UserModel, noteData: CityModel? = nil) {
		//self.router = router
		self.notesStorage = notesStorage
		//self.configurationReader = configurationReader
		self.center = center
		//self.backupManager = backupManager
		self.user = user
		self.noteData = noteData
//		self.center.addObserver(self, selector: #selector(reloadNotes),
//								name: Notification.Name.updateNotification,
//								object: nil)
	}
}

extension MainScreenPresenter {
	func viewDidLoad(view: MainScreenTableAdapter) {
		self.adapter = view
		displayNotes()
		companiesCount()
		
//		self.adapter?.imagesCountHandler = { [weak self] in
//			return 4
//		}
//		self.adapter?.cellWillShowHandler = { [weak self] cell, index in
//			self?.cellWillShow(cell, at: index)
//		}
	}
	
	func companiesCount() -> Int {
		print("count")
		return self.model?.count ?? 0
	}

	func saveCity(city: String) {
		
		let citys = CityModel(holder: self.user.uid, name: "lol")
		self.notesStorage.addNewEmployee(withEmployee: citys, forCompany: self.user)
		//	print(newEmployee.workExperience)
		//	self.loadEmployees()
		//	self.viewController?.refreshTable()
		
		
//		let city = CityModel(holder: self.user.uid, name: city)
//		self.notesStorage.create(city: citys, completion: { error in
//				if error == nil {
//					print("Удачно")
//				} else {
//					self.controller?.showAlert(message: "Ошибка создания записи")
//					print("Ошибка создания записи")
//				}
//		})
		
		displayNotes()
	}
	
	func displayNotes() {
		let models = self.notesStorage.getNotes(for: self.user)
		let modelss = models.map { Model(id: $0.uid, name: $0.name) }

		//model = self.notesStorage.getNotes(for: self.user)
//		//let modelsss = model.map { Model(id: $0., holder: $0.holder, name: $0.name) }
//		print("model")
//		//print("loadEmployees: \(model.map{Model(id: $0, name: $0.password)})")
//		print("models")
//		print(models.count)
		print("modelss - размер массива после выгрузки")
		print(modelss.count)
		print(modelss)
		
		let user = self.notesStorage.loadCompanies()
		print("user: \(user.map{Model(id: $0.uid, name: $0.password)})")
		
		
	}
	
	
	private func cellWillShow(_ cell: MainScreenNoteCell, at index: Int) {
		guard index >= 0 , index < 100 else {
			assert(true, "wrong index")
			return
		}
//		do {
//
//			self.notes = try self.notesStorage.getNotes(for: self.user)
//		} catch {
//			self.controller?.showAlert(message: "Ошибка загрузки данных")
//			self.notes = []
//		}
		
//		self.notes.map{
//			let presenter = MainScreenCellPresenter(cityModel: notes.map)
//			self.mainScreenCellPresenter.append(presenter)
//		}
//		let presenter = MainScreenCellPresenter(cityModel: notes.map)
//		self.mainScreenCellPresenter.append(presenter)
//		print(city)
		//let imagePresenter = self.mainScreenCellPresenter[index]
		//imagePresenter.didLoadView(view: cell)
	}
	
	func showCity(city:String?) {
//		guard let url = city else {return}
//		self.networkService.performRequest(withURLString: url) {  reslut in
//			switch reslut {
//			case .success(let webModel):
//				DispatchQueue.main.async {
//					let presenter = MainScreenCellPresenter(cityModel: webModel)
//					self.mainScreenCellPresenter.append(presenter)
//					self.adapter?.update()
//					//print(webModel)
//					print(self.mainScreenCellPresenter)
//				}
//				case .failure(let error):
//				//self.view?.activityIndicator.stopAnimating()
//				if !(url.isEmpty) {
//					//let alert = AlertController()
//					print(error)
//					//alert.showAlert(title: "Error", message: "Что-то пошло не так")
//				}
//			}
//		}
	}
	func parseJson(city:String?) {
		
	}
}
private extension MainScreenPresenter {
}
