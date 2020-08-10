//
//  CHBannerView
//
//  Created by chinghoi on 2020/8/10.
//

import UIKit
import AlamofireImage

class CHBannerCollectionViewCell: UICollectionViewCell {
    
    private var cacheCustomView: UIView?
    
    public final let imageView: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(data: CHBanner) {
        if let urlStr = data.url, let url = try? urlStr.asURL() {
            imageView.af.setImage(withURL: url, cacheKey: url.absoluteString, placeholderImage: data.placeholder)
        } else {
            imageView.image = data.image
        }
    }
    
    func setCell(data: UIView) {
        imageView.isHidden = true
        guard data != cacheCustomView else { return }
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(data)
        data.frame = contentView.bounds
    }
    
    func setCellStyle(_ preference: CHBannerItemStyle) {
        
        contentView.backgroundColor = preference.backgroundColor
        
        imageView.contentMode = preference.imageViewContentMode
    }
}
