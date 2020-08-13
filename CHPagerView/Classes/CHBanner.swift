//
//  CHPagerView
//
//  Created by chinghoi on 2020/8/10.
//

import UIKit

public struct CHBanner {
    public var url: String?
    public var placeholder: UIImage?
    public var image: UIImage?
    
    public init(url: String? = nil, placeholder: UIImage? = nil, image: UIImage? = nil) {
        self.url = url
        self.placeholder = placeholder
        self.image = image
    }
}
