//
//  MainScreenNoteCell.swift
//  forcastW
//
//  Created by Никита on 17.06.2021.
//
import Foundation
import UIKit

final class MainScreenNoteCell: UITableViewCell {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		self.backgroundColor = .secondarySystemBackground
		self.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//		self.contentView.addSubview(self.time)
//		self.time.snp.makeConstraints { maker in
//			maker.right.top.equalToSuperview().inset(5)
//			maker.centerY.equalToSuperview()
//		}
//		self.textLabel?.snp.makeConstraints { maker in
//			maker.right.top.equalToSuperview().inset(5)
//			maker.centerY.equalToSuperview()
//		}
	}

	fileprivate(set) lazy var time: UILabel = {
		let view = UILabel()
		//view.font = UIFont.systemFont(ofSize: 2)
		view.textColor = .red
		return view
	}()


	func update(vm: MainScreenItemViewModel) {
		//self.time.text = "+25"
		self.textLabel?.text = vm.name
		self.detailTextLabel?.text = vm.cold
		print("111111")
		//print(vm.cold)
		self.imageView?.image = UIImage(systemName: "sun.min")
//		let clearMainText = vm.name?.replacingOccurrences(of: "\n", with: "", options: .literal, range: nil)
//		self.detailTextLabel?.text = clearMainText
	}
}

