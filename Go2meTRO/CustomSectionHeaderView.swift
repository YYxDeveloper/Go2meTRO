//
//  CustomSectionHeaderView.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/2/14.
//

import Foundation
import UIKit
class CustomSectionHeaderView: UITableViewHeaderFooterView {
    
    static let height = 120.0
    
    let tramImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "tram.circle")
        imageView.tintColor = UIColor(hex: DanhaiLRTRouteManager.witchLRTColor.red.rawValue)
        return imageView
    }()
    let downDirectionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "arrow.down.forward.circle")
        imageView.tintColor = UIColor(hex: DanhaiLRTRouteManager.witchLRTColor.red.rawValue)
        return imageView
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        
        
        contentView.addSubview(tramImageView)
        contentView.addSubview(downDirectionImage)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            tramImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            tramImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            tramImageView.widthAnchor.constraint(equalToConstant: 70),
            tramImageView.heightAnchor.constraint(equalToConstant: 70),
            
            downDirectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -15),
            downDirectionImage.topAnchor.constraint(equalTo: tramImageView.bottomAnchor, constant: 0),
            downDirectionImage.widthAnchor.constraint(equalToConstant: 50),
            downDirectionImage.heightAnchor.constraint(equalToConstant: 50),
            
            
            
        ])
    }
}
