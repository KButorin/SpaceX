//
//  MainViewController.swift
//  SpaceX
//
//  Created by ESSIP on 01.12.2024.
//

import Foundation
import UIKit
import SDWebImage

final class MainViewController: UIViewController {
    
    //MARK: -Properties
    
    private var launches: [Launch] = []
    private var rockets: [Rockets] = []
    private let rocketsViewModel = RocketsViewModel()
    private let launchesViewModel = LaunchesViewModel(launchRequest: LaunchesRequest())
    private var parameters: [(value: String, description: String)] = []
    private var detailInfo: [(title: String, info: String)] = []
    private var stagesDetailInfo: [(title: String, info: String)] = []
    
    private lazy var rocketsCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: view.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.register(RocketCell.self, forCellWithReuseIdentifier: RocketCell.reuseIdentifier)
        return view
    }()
    
    private lazy var parametersCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(ParametersCell.self, forCellWithReuseIdentifier: ParametersCell.identifier)
        return view
    }()
    
    private lazy var detailInfoCollecionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
        layout.minimumLineSpacing = 10
        //        layout.minimumInteritemSpacing = 5
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(DetailInfoCell.self, forCellWithReuseIdentifier: DetailInfoCell.identifier)
        return view
    }()
    
    private lazy var rocketStagesDetailInfoCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
        layout.minimumLineSpacing = 10
        //        layout.minimumInteritemSpacing = 5
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(RocketStagesDetailInfoCell.self, forCellWithReuseIdentifier: RocketStagesDetailInfoCell.identifier)
        return view
    }()
    
    private lazy var sheetView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.addSubview(scrollView)
        return view
    }()
    
    private var rocketNameLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.isUserInteractionEnabled = false
        //        pageControl.numberOfPages = 5
        return pageControl
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = ScrollView()
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        return stackView
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let launchesVCButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Launches", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        button.addTarget(self, action: #selector(launchesVCButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: -PageControl
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = rocketsCollectionView.frame.size.width
        if width > 0 {
            pageControl.numberOfPages = rockets.count
            print("Width of rocketsCollectionView: \(width)")
        }
        if rocketsCollectionView.isDragging == false {
            let offsetX = rocketsCollectionView.contentOffset.x
            let pageIndex = Int(offsetX / width)
            pageControl.currentPage = pageIndex
        }
    }
    //MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        fetchRocketsData()
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        launchesVCButton.translatesAutoresizingMaskIntoConstraints = false
        
        parametersCollectionView.isScrollEnabled = false
        detailInfoCollecionView.isScrollEnabled = false
        rocketStagesDetailInfoCollectionView.isScrollEnabled = false
        
        rocketsCollectionView.delegate = self
        rocketsCollectionView.dataSource = self
        parametersCollectionView.dataSource = self
        parametersCollectionView.delegate = self
        detailInfoCollecionView.delegate = self
        detailInfoCollecionView.dataSource = self
        rocketStagesDetailInfoCollectionView.delegate = self
        rocketStagesDetailInfoCollectionView.dataSource = self
        
        self.navigationController?.navigationBar.tintColor = .white
        
    }
}

//MARK: -Extensions

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == rocketsCollectionView {
            return rockets.count
        } else if collectionView == parametersCollectionView {
            return parameters.count
        } else if collectionView == detailInfoCollecionView {
            return detailInfo.count
        } else if collectionView == rocketStagesDetailInfoCollectionView {
            return stagesDetailInfo.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Configuring cell for item at index: \(indexPath.item)")
        
        if collectionView == rocketsCollectionView {
            guard let cell = rocketsCollectionView.dequeueReusableCell(withReuseIdentifier: RocketCell.reuseIdentifier, for: indexPath) as? RocketCell else {
                return UICollectionViewCell()
            }
            
            let rocket = rockets[indexPath.row]
            let imageUrl = rocket.flickrImages?.first
            cell.configure(with: rocket, imageUrl: imageUrl)
            return cell
            
        } else if collectionView == parametersCollectionView {
            guard let cell = parametersCollectionView.dequeueReusableCell(withReuseIdentifier: ParametersCell.identifier, for: indexPath) as? ParametersCell else {
                return UICollectionViewCell()
            }
            let parameter = parameters[indexPath.row]
            cell.configure(value: parameter.value, description: parameter.description)
            return cell
            
        } else if collectionView == detailInfoCollecionView {
            guard let cell = detailInfoCollecionView.dequeueReusableCell(withReuseIdentifier: DetailInfoCell.identifier, for: indexPath) as? DetailInfoCell else {
                return UICollectionViewCell()
            }
            
            let detailInfo = detailInfo[indexPath.row]
            cell.configure(title: detailInfo.title, info: detailInfo.info)
            return cell
            
        } else if collectionView == rocketStagesDetailInfoCollectionView {
            guard let cell = rocketStagesDetailInfoCollectionView.dequeueReusableCell(withReuseIdentifier: RocketStagesDetailInfoCell.identifier, for: indexPath) as? RocketStagesDetailInfoCell else {
                return UICollectionViewCell()
            }
            let stagesInfo = stagesDetailInfo[indexPath.row]
            cell.configure(title: stagesInfo.title, info: stagesInfo.info)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == rocketsCollectionView {
            let width = scrollView.frame.size.width
            let offsetX = scrollView.contentOffset.x
            
            if width > 0 {
                let pageIndex = Int(offsetX / width)
                pageControl.currentPage = pageIndex
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == rocketsCollectionView {
            let width = scrollView.frame.size.width
            let currentPage = Int(scrollView.contentOffset.x / width)
            updateRocketData(for: currentPage)
        }
    }
    
    //MARK: - Update data
    private func updateRocketData(for index: Int) {
        guard rockets.indices.contains(index) else { return }
        let rocket = rockets[index]
        
        parameters = [
            (value: "\(rocket.height.feet ?? 0)", description: "Высота, ft"),
            (value: "\(rocket.diameter.feet ?? 0)", description: "Диаметр, ft"),
            (value: "\(rocket.mass.lb)", description: "Масса, lb"),
            (value: "\(rocket.firstStage?.engines ?? 0)", description: "Двигатели")
        ]
        parametersCollectionView.reloadData()
        
        detailInfo = [
            (title: "Первый запуск", info: "\(rocket.firstFlight ?? "No first flight")"),
            (title: "Страна", info: "\(rocket.country)"),
            (title: "Стомость запуска", info: "$\(rocket.costPerLaunch ?? 0)")
        ]
        detailInfoCollecionView.reloadData()
        
        stagesDetailInfo = [
            (title: "Первая ступень", info: ""),
            (title: "Количество двигателей", info: "\(rocket.firstStage?.engines ?? 0)"),
            (title: "Количество топлива", info: "\(rocket.firstStage?.fuelAmountTons ?? 0) ton"),
            (title: "Время сгорания в секундах", info: "\(rocket.firstStage?.burnTimeSEC ?? 0) сек"),
            (title: "Вторая ступень", info: ""),
            (title: "Количество двигателей", info: "\(rocket.secondStage?.engines ?? 0)"),
            (title: "Количество топлива", info: "\(rocket.secondStage?.fuelAmountTons ?? 0) ton"),
            (title: "Время сгорания в секундах", info: "\(rocket.secondStage?.burnTimeSEC ?? 0) сек"),
        ]
        rocketStagesDetailInfoCollectionView.reloadData()
        
        rocketNameLabel.text = rocket.name
    }
    
    //MARK: -Buttons methods
    
   @objc private func settingsButtonTapped(){
       let settingsViewController = SettingsViewController()
       let navigationController = UINavigationController(rootViewController: settingsViewController)
       self.present(navigationController, animated: true)
    }
    
    @objc private func launchesVCButtonTapped(){
        let launchesVC = LaunchesViewController()
            if let navigationController = self.navigationController {
                navigationController.pushViewController(launchesVC, animated: true)
            } else {
                print("No navigation controller")
            }
    }
    
}


private extension MainViewController {
    
    private func setupUI() {
        view.addSubview(rocketsCollectionView)
        view.addSubview(sheetView)
        
//        rocketsCollectionView.addSubview(settingsButton)
//        rocketsCollectionView.addSubview(launchesVCButton)
        
        
        sheetView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addSubview(launchesVCButton)
        stackView.addSubview(settingsButton)
        stackView.addArrangedSubview(rocketNameLabel)
        stackView.addArrangedSubview(parametersCollectionView)
        stackView.addArrangedSubview(detailInfoCollecionView)
        stackView.addArrangedSubview(rocketStagesDetailInfoCollectionView)
        view.addSubview(pageControl)
    }
    
    private func setupConstraints() {
    
        rocketsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        sheetView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(rocketsCollectionView.snp.bottom)
//            make.height.equalTo(600)
        }
        
        settingsButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(55)
            make.trailing.equalToSuperview().inset(40)
            make.top.equalToSuperview().inset(45)
        }
        
        launchesVCButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(140)
            make.top.equalToSuperview().inset(35)
            make.size.equalTo(CGSize(width: 150, height: 50))
        }
        
        scrollView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(view.frame.width)
        }
        
        rocketNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(sheetView.snp.top).inset(45)
        }
        
        parametersCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(sheetView.snp.top).inset(100)
            make.trailing.equalToSuperview().inset(25)
            make.height.equalTo(100)
        }
        
        detailInfoCollecionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.trailing.equalToSuperview().inset(25)
            make.top.equalTo(sheetView.snp.top).inset(250)
            make.height.equalTo(130)
        }
        
        rocketStagesDetailInfoCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.trailing.equalToSuperview().inset(25)
            make.top.equalTo(sheetView.snp.top).inset(390)
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()  // Центрируем по горизонтали
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    //MARK: -FetchDataMethod
    
    private func fetchRocketsData() {
        RocketsRequest.shared.fetchData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rocketsData):
                    print("Fetched rockes: \(rocketsData)")
                    self?.rockets = rocketsData
                    self?.rocketsCollectionView.reloadData()
                    
                    self?.pageControl.numberOfPages = rocketsData.count
                    
                    guard let rocket = rocketsData.first else { return }
                    self?.parameters = [
                        (value: "\(rocket.height.feet ?? 0)", description: "Высота, ft"),
                        (value: "\(rocket.diameter.feet ?? 0)", description: "Диаметр, ft"),
                        (value: "\(rocket.mass.lb)", description: "Масса, lb"),
                        (value: "\(rocket.firstStage?.engines ?? 0)", description: "Двигатели")
                    ]
                    self?.parametersCollectionView.reloadData()
                    
                    if let info = rocketsData.first {
                        self?.detailInfo = [
                            (title: "Первый запуск ", info: "\(info.firstFlight ?? "No first flight")"),
                            (title: "Страна", info: "\(info.country)"),
                            (title: "Стомость запуска", info: "$\(info.costPerLaunch ?? 0)" ),
                        ]
                        self?.detailInfoCollecionView.reloadData()
                    }
                    
                    if let stagesInfo = rocketsData.first {
                        self?.stagesDetailInfo = [
                            
                            // Информация о первой ступени
                            (title: "Первая ступень", info: ""),
                            (title: "Количество двигателей", info: "\(rocket.firstStage?.engines ?? 0)"),
                            (title: "Количество топлива", info: "\(rocket.firstStage?.fuelAmountTons ?? 0) ton"),
                            (title: "Время сгорания в секундах", info: "\(rocket.firstStage?.burnTimeSEC ?? 0) ton"),
                            
                            // Информация о второй ступени
                            (title: "Вторая ступень", info: ""),
                            (title: "Количество двигателей", info: "\(rocket.secondStage?.engines ?? 0)"),
                            (title: "Количество топлива", info: "\(rocket.secondStage?.fuelAmountTons ?? 0) ton"),
                            (title: "Время сгорания в секундах", info: "\(rocket.secondStage?.burnTimeSEC ?? 0) ton"),
                        ]
                        self?.rocketStagesDetailInfoCollectionView.reloadData()
                    }
                    
                    if let rocketName = rocketsData.first {
                        self?.rocketNameLabel.text = rocketName.name
                    }
                    
                case .failure(let error):
                    print("Failed to fetch launches: \(error)")
                }
            }
        }
    }
}


#Preview {
    MainViewController()
}
