//
//  SettingsCell.swift
//  SpaceX
//
//  Created by ESSIP on 09.12.2024.
//

import Foundation
import UIKit
import SnapKit

class SettingsCell: UITableViewCell {
    
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.selectedSegmentTintColor = .white
        control.backgroundColor = UIColor.black
        control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        return control
    }()
    
    var onOptionSelected: ((Int) -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SettingsCell {
    
    private func setupUI(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(segmentedControl)
    }
    
    private func setupConstraints(){
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
    
}

extension SettingsCell {
    
    public func configure(with title: String, options: [String], selectedIndex: Int) {
        self.titleLabel.text = title
        segmentedControl.removeAllSegments()
        
        for (index, option) in options.enumerated() {
            segmentedControl.insertSegment(withTitle: option, at: index, animated: false)
        }
        
        segmentedControl.selectedSegmentIndex = selectedIndex
    }
    
    @objc private func segmentChanged() {
        onOptionSelected?(segmentedControl.selectedSegmentIndex)
    }
}
