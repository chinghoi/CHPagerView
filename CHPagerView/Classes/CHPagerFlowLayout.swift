//
//  CHPagerView
//
//  Created by chinghoi on 2020/8/10.
//

import UIKit

class CHPagerFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        /// 建议的点（在集合视图的内容视图中），在该点停止滚动。这是如果不进行任何调整自然会停止滚动的值。该点反映了可见内容的左上角。
        
        guard let collectionView = collectionView else {
            return .zero
        }
        if scrollDirection == .horizontal {
            let pageWidth = self.itemSize.width + self.minimumLineSpacing

            let approximatePage = (collectionView.contentOffset.x + collectionView.contentInset.left) / pageWidth

            let currentPage = velocity.x == 0 ? round(approximatePage) : (velocity.x < 0.0 ? floor(approximatePage) : ceil(approximatePage))

            let flickVelocity = velocity.x * 1

            let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)

            let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - collectionView.contentInset.left

            return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
        } else {
            // Page height used for estimating and calculating paging.
            let pageHeight = self.itemSize.height + self.minimumLineSpacing

            // Make an estimation of the current page position.
            let approximatePage = (collectionView.contentOffset.y + collectionView.contentInset.top) / pageHeight

            // Determine the current page based on velocity.
            let currentPage = velocity.y == 0 ? round(approximatePage) : (velocity.y < 0.0 ? floor(approximatePage) : ceil(approximatePage))

            // Create custom flickVelocity.
            let flickVelocity = velocity.y * 1

            // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
            let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)

            let newVerticalOffset = ((currentPage + flickedPages) * pageHeight) - collectionView.contentInset.top

            return CGPoint(x: proposedContentOffset.x, y: newVerticalOffset)
        }
    }
    
}
