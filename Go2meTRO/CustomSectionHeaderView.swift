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
    let headLineLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFit
        label.font =  UIFont.systemFont(ofSize: 30.0)
        label.textAlignment = .center
        return label
    }()
    let subTitleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFit
        label.font =  UIFont.systemFont(ofSize: 18.0)
        label.textAlignment = .center

        return label
    }()
    let tramImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setttingShadow()
      
        return imageView
    }()
    let upDirectionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    let downDirectionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    let dividLine:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
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
        contentView.addSubview(upDirectionImage)
        contentView.addSubview(dividLine)
        contentView.addSubview(headLineLable)
        contentView.addSubview(subTitleLable)

        // Set up constraints
        let squarLength = 50.0
        let margin = 15.0
        NSLayoutConstraint.activate([
            tramImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            tramImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tramImageView.widthAnchor.constraint(equalToConstant: 70),
            tramImageView.heightAnchor.constraint(equalToConstant: 70),
            
            upDirectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -margin),
            upDirectionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            upDirectionImage.widthAnchor.constraint(equalToConstant: squarLength),
            upDirectionImage.heightAnchor.constraint(equalToConstant: squarLength),
            
            downDirectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -margin),
            downDirectionImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            downDirectionImage.widthAnchor.constraint(equalToConstant: squarLength),
            downDirectionImage.heightAnchor.constraint(equalToConstant: squarLength),
            
            dividLine.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: margin),
            dividLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dividLine.widthAnchor.constraint(equalToConstant: 200),
            dividLine.heightAnchor.constraint(equalToConstant: 2),
            
            headLineLable.bottomAnchor.constraint(equalTo: dividLine.topAnchor, constant: margin),
            headLineLable.leadingAnchor.constraint(equalTo: dividLine.leadingAnchor),
            headLineLable.trailingAnchor.constraint(equalTo: dividLine.trailingAnchor),
            headLineLable.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            subTitleLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            subTitleLable.leadingAnchor.constraint(equalTo: dividLine.leadingAnchor),
            subTitleLable.trailingAnchor.constraint(equalTo: dividLine.trailingAnchor),
            subTitleLable.topAnchor.constraint(equalTo: dividLine.bottomAnchor),

        ])
    }
    func defaultSeting(witchLRTLine:DanhaiLRTRouteManager.witchLRTLine) {
        switch witchLRTLine {
        
        case .upToHongshulin:
            self.tramImageView.image = UIImage(systemName: "tram.circle")
            self.tramImageView.tintColor = UIColor(hex: DanhaiLRTRouteManager.witchLRTColor.red.rawValue)
            
            self.upDirectionImage.image = UIImage(systemName: "arrow.up.right.square.fill")
            self.upDirectionImage.tintColor = UIColor(hex: DanhaiLRTRouteManager.witchLRTColor.red.rawValue)
            self.upDirectionImage.isHidden = false
            
            self.downDirectionImage.image = UIImage(systemName: "arrow.down.forward.circle")
            self.downDirectionImage.tintColor = UIColor(hex: DanhaiLRTRouteManager.witchLRTColor.red.rawValue)
            self.downDirectionImage.isHidden = true
            
            dividLine.backgroundColor = UIColor(hex:  DanhaiLRTRouteManager.witchLRTColor.red.rawValue)

            
        case .upToKanding:
            break
        case .upToWahrf:
            break
        case .downToToKanding:
            break
        case .downToWahrf:
            break
        case .downToHongshulin:
            break
        }
    }
}
extension UIImageView {
    fileprivate func setttingShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
    }
}
