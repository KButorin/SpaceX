//
//  LaunchesCell.swift
//  SpaceX
//
//  Created by ESSIP on 12.12.2024.
//

import Foundation
import SnapKit
import UIKit


class LaunchesCell: UITableViewCell {
    
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let rocketImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let launchBackgroundView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 12/255, green: 11/255, blue: 13/255, alpha: 1.0)
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
        
    }
    
    static var identifier: String {String(describing: self)}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LaunchesCell {
    
    private func setupUI() {
        contentView.addSubview(launchBackgroundView)
        launchBackgroundView.addSubview(titleLabel)
        launchBackgroundView.addSubview(dateLabel)
        launchBackgroundView.addSubview(rocketImageView)
    }
    
    private func setupConstraints(){
        
        launchBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(26)
            make.trailing.equalToSuperview().inset(26)
            make.top.bottom.equalToSuperview().inset(8) // Позволяет автоматически подстраиваться под высоту содержимого
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(22)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel).inset(22)
        }
        
        rocketImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(22)
        }
        
        
    }
    
    public func setupData(with title: String, date: String?, isSuccess: Bool){
        self.titleLabel.text = title
        self.dateLabel.text = date ?? "no date"
        self.rocketImageView.image  = isSuccess ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "x.circle.fill")
    }
    
    
}
