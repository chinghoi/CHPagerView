//
//  CHBannerView
//
//  Created by chinghoi on 2020/8/10.
//

import UIKit

public protocol CHBannerViewDelegate: class {
    func bannerView(_ bannerView: CHBannerView, didSelectItemAt index: Int)
    func bannerViewDidEndScroll(_ bannerView: CHBannerView, current index: Int)
}
extension CHBannerViewDelegate {
    public func bannerView(_ bannerView: CHBannerView, didSelectItemAt index: Int) {}
    public func bannerViewDidEndScroll(_ bannerView: CHBannerView, current index: Int) {}
}
