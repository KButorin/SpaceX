//
//  LaunchesViewController.swift
//  SpaceX
//
//  Created by ESSIP on 01.12.2024.
//

import Foundation
import UIKit

class LaunchesViewController: UIViewController {
    
    //MARK: -Properties
    
    private var launches: [Launch] = []
    
    private let launchesTableView = {
        let tableView = UITableView()
        tableView.rowHeight = 105
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LaunchesCell.self, forCellReuseIdentifier: LaunchesCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .black
        self.title = "Launches"
        setupUI()
        sutupConststraints()
        fetchLaunchesData()
        launchesTableView.delegate = self
        launchesTableView.dataSource = self
    }
    
    
}

extension LaunchesViewController {
    
    private func setupUI() {
        view.addSubview(launchesTableView)
    }
    
    private func sutupConststraints(){
        launchesTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func fetchLaunchesData(){
        LaunchesRequest.shared.fetchData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let launchesData):
                    self?.launches = launchesData
                    self?.launchesTableView.reloadData()
                case .failure(let failure):
                    print("failure = \(failure.localizedDescription)")
                }
            }
        }
    }
    
}


extension LaunchesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchesCell.identifier, for: indexPath) as? LaunchesCell else {
            return UITableViewCell()
        }
        
        let launch = launches[indexPath.row]
        let isSuccessfull = launch.success ?? false
        let date = launch.dateUTC ?? "no date"
        cell.setupData(with: launch.name ?? "no name", date: launch.dateUTC ?? "no date", isSuccess: isSuccessfull)
        return cell
    }
}


