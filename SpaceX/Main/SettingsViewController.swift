//
//  SettingsViewController.swift
//  SpaceX
//
//  Created by ESSIP on 01.12.2024.
//

import Foundation
import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    //MARK: -Properties
    
    private let settingsOptions = [
        ("Высота", ["m", "ft"]),
        ("Диаметр", ["m", "ft"]),
        ("Масса", ["kg", "lb"]),
        ("Полезная нагрузка", ["kg", "lb"])
    ]
    
    var selectedOptions: [Int] = [0, 0, 0, 0]
    
    private let settingsCellTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.rowHeight = 60
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(closeVC))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        view.backgroundColor = .black
        settingsCellTableView.dataSource = self
        settingsCellTableView.delegate = self
        
        setupUI()
        setupConstraints()
    }
    
}
//MARK: -Extensions

extension SettingsViewController {
    
    private func setupUI(){
        view.addSubview(settingsCellTableView)
    }
    
    private func setupConstraints() {
        settingsCellTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70) 
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    @objc func closeVC(){
        self.dismiss(animated: true)
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        let option = settingsOptions[indexPath.row]
        cell.configure(with: option.0, options: option.1, selectedIndex: selectedOptions[indexPath.row])
        
        cell.onOptionSelected = { [weak self] selectedIndex in
            self?.selectedOptions[indexPath.row] = selectedIndex
            print("\(option.0) выбран: \(option.1[selectedIndex])")
        }
        return cell
    }
}
