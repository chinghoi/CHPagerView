//
//  CHBannerCustomCollectionViewCell.swift
//  Alamofire
//
//  Created by chinghoi on 2020/8/12.
//

import UIKit

class CHBannerCustomCollectionViewCell: UICollectionViewCell {
    
    var customView: UIView?
    
    func setCell(customView: UIView) {
        self.customView = customView
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        customView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}
