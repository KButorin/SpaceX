//
//  ParametrsCell.swift
//  SpaceX
//
//  Created by ESSIP on 01.12.2024.
//

import Foundation
import UIKit
import SnapKit
        
class ParametersCell: UICollectionViewCell {
    
    //MARK: -Properties
    
    private let valueLabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "My text 220"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "My Height"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    //MARK: -Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1)
        setupUI()
        setupLayout()
    }
    
    static var identifier: String {String(describing: self)}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#Preview {
    ParametersCell()
}

//MARK: -Extensions

private extension ParametersCell {
    
    //MARK: -Setup
    private func setupUI(){
        layer.cornerRadius = 30
        contentView.addSubview(valueLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupLayout(){
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
    }
    //MARK: -Configure
    public func configure(value: String, description: String) {
        self.valueLabel.text = value
        self.descriptionLabel.text = description
    }
    
}

