//
//  CHPagerView
//
//  Created by chinghoi on 2020/8/10.
//

import UIKit

public protocol CHPagerViewDelegate: class {
    func pagerView(_ pagerView: CHPagerView, didSelectItemAt index: Int)
    func pagerViewDidEndScroll(_ pagerView: CHPagerView, current index: Int)
}
extension CHPagerViewDelegate {
    public func pagerView(_ pagerView: CHPagerView, didSelectItemAt index: Int) {}
    public func pagerViewDidEndScroll(_ pagerView: CHPagerView, current index: Int) {}
}
