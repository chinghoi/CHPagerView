//
//  CHPagerView
//
//  Created by chinghoi on 2020/8/10.
//

import UIKit

/// CHPagerView data Type
/// - url: String? { get set }
/// - placeholder: UIImage? { get set }
/// - image: UIImage? { get set }
public protocol CHDatable {
    var url: String? { get set }
    var placeholder: UIImage? { get set }
    var image: UIImage? { get set }
    var customView: UIView? { get set }
}
extension CHDatable {
    var placeholder: UIImage? { return nil }
    var image: UIImage? { return nil }
    var customView: UIView? { return nil }
}
