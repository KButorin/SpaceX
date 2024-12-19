//
//  RocketCell .swift
//  SpaceX
//
//  Created by ESSIP on 03.12.2024.
//

import Foundation
import SDWebImage
import UIKit

//UIPageViewController 

class RocketCell: UICollectionViewCell {
    
    //MARK: -Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        return imageView
    }()

    
    //MARK: -Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        //        contentView.addSubview(rocketNameLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        rocketNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        imageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
                imageView.frame = CGRect(x: 0, y: -33, width: contentView.frame.width, height: contentView.frame.height)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var reuseIdentifier: String { String(describing: self) }
    
    //MARK: -ConfigureMethod
    
    public func configure(with rocket: Rockets, imageUrl: String?) {
        
        // Устанавливаем изображение через SDWebImage
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
}


