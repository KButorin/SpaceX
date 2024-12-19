//
//  RocketStagesDetailInfo.swift
//  SpaceX
//
//  Created by ESSIP on 08.12.2024.
//

import Foundation


import Foundation
import UIKit
import SnapKit

class RocketStagesDetailInfoCell: UICollectionViewCell {
    
    //MARK: -Properties
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .label
        return label
    }()
    
    private let infoLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .white
        return label
    }()
    
    //MARK: -Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCostraints()
    }
    
    static var identifier: String {String(describing: self)}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -Extension
extension RocketStagesDetailInfoCell {
    
    private func setupUI(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
    }
    
    private func setupCostraints(){
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(28)
            make.centerY.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
    }
    
    public func configure(title: String, info: String){
        self.titleLabel.text = title
        if info.isEmpty {
            self.infoLabel.text = "" 
            self.titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
            self.titleLabel.text = title.uppercased()
        } else {
            self.infoLabel.text = info
            self.titleLabel.font = .systemFont(ofSize: 16, weight: .light)
        }
    }
}
