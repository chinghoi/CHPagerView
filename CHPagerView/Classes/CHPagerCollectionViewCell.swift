//
//  CHPagerView
//
//  Created by chinghoi on 2020/8/10.
//

import UIKit

class CHPagerCollectionViewCell: UICollectionViewCell {
    
    private var cache: CHDatable?
    
    public final lazy var imageView: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        return i
    }()
    
    public var customView = UIView()
    
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
    
    func setURL(_ url: String, placeholder: UIImage?) {
        imageView.image = placeholder
        imageView.loadWith(url: url)
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func setCell(data: CHDatable) {
        if let cv = data.customView {
            self.customView = cv
            contentView.addSubview(customView)
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            customView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        } else if let img = data.image {
            setImage(img)
        } else if let url = data.url {
            setURL(url, placeholder: data.placeholder)
        } else {
            contentView.subviews.forEach{ $0.removeFromSuperview() }
            imageView.image = nil
        }
    }
    
    func setCellStyle(_ preference: CHPagerItemStyle) {
        
        contentView.backgroundColor = preference.backgroundColor
        
        imageView.contentMode = preference.imageViewContentMode
    }
    
}
