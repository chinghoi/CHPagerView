//
//  CHBannerView
//
//  Created by chinghoi on 2020/8/10.
//

import UIKit
import AlamofireImage

/// BannerView, support set to UIView array, or default Banner class array.
public class CHBannerView: UIView {
    
    public weak var delegate: CHBannerViewDelegate?
    public var didSelectItem: ((_ bannerView: CHBannerView, _ index: Int) -> Void)?
    
    // MARK: - Public
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    /// Constants indicating the direction of scrolling for the layout.
    public var scrollDirection: UICollectionView.ScrollDirection {
        set { layout.scrollDirection = newValue }
        get { layout.scrollDirection }
    }
    
    /// Automatic rotation interval, default is 3 seconds.
    /// The number of seconds between firings of the timer.
    /// If interval is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead.
    public var timeInterval: TimeInterval = 3
    
    /// Is Automatic rotation, default is true
    public var isAutoRotation: Bool = true
    
    public var itemStyle = CHBannerItemStyle() { didSet { collectionView.reloadData() } }
    
    public override var backgroundColor: UIColor? {
        set { collectionView.backgroundColor = newValue }
        get { collectionView.backgroundColor }
    }
    
    public var backgroundView: UIView? {
        set { collectionView.backgroundView = newValue }
        get { collectionView.backgroundView }
    }
    
    private var currentIndex: Int = 1
//    private var isNeedSetContentOffset = false // 判断是否需要复位到第一个数据的位置或复位到最后一个数据的位置
    private var timer: Timer?
    /// 传入的数据的基础上 ，首部加入了最后一个数据， 尾部加入了第一个数据。该数据总长度为 原数据 + 2
    private var data: [Any] = []
    private var layout = BannerFlowLayout()
    
    private lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        v.register(BannerCollectionViewCell.self)
        v.bounces = false
        v.isPagingEnabled = false
        v.decelerationRate = .fast
        v.dataSource = self
        v.delegate = self
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        return v
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard layout.itemSize != bounds.inset(by: edgeInsets).size else { return }
        layout.itemSize = bounds.inset(by: edgeInsets).size
        
        if scrollDirection == .horizontal {
            layout.minimumLineSpacing = edgeInsets.left + edgeInsets.right
        } else {
            layout.minimumLineSpacing = edgeInsets.top + edgeInsets.bottom
        }
        
        collectionView.frame = self.bounds
        collectionView.contentInset = edgeInsets
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    public func setData(data: [CHBanner]) {
        setData(any: data)
    }
    
    public func setData(data: [UIView]) {
        setData(any: data)
    }
    
    private func setData(any: [Any]) {
        guard any.count >= 1 else { return }
        self.data = [any.last!] + any + [any.first!]
        collectionView.reloadData()
        DispatchQueue.main.async {
            if self.scrollDirection == .horizontal {
                self.collectionView.contentOffset = CGPoint(x: self.bounds.width - self.edgeInsets.left, y: -self.edgeInsets.top)
            } else {
                self.collectionView.contentOffset = CGPoint(x: -self.edgeInsets.left, y: self.bounds.height - self.edgeInsets.top)
            }
        }

        guard isAutoRotation else {
            timer?.invalidate()
            timer = nil
            return
        }
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScrollAction), userInfo: nil, repeats: true)
    }
    
    @objc
    private func autoScrollAction() {
        if currentIndex == data.count - 1 {
            scrollToFirstDataOnMain()
        }
        DispatchQueue.main.async {
            let nextOffset: CGPoint
            if self.scrollDirection == .horizontal {
                nextOffset = CGPoint(x: CGFloat(self.currentIndex + 1) * self.bounds.width  - self.edgeInsets.left, y: -self.edgeInsets.top)
            } else {
                nextOffset = CGPoint(x: -self.edgeInsets.left, y: CGFloat(self.currentIndex + 1) * self.bounds.height  - self.edgeInsets.top)
            }
            self.collectionView.setContentOffset(nextOffset, animated: true)
            self.collectionView.isUserInteractionEnabled = false
        }
    }
    private func scrollToFirstDataOnMain() {
        DispatchQueue.main.async {
            let offset: CGPoint
            if self.scrollDirection == .horizontal {
                offset = CGPoint(x: self.bounds.width - self.edgeInsets.left, y: -self.edgeInsets.top)
            } else {
                offset = CGPoint(x: -self.edgeInsets.left, y: CGFloat(self.bounds.height - self.edgeInsets.top))
            }
            self.collectionView.contentOffset = offset
        }
    }
    private func scrollToLastDataOnMain() {
        DispatchQueue.main.async {
            let offset: CGPoint
            if self.scrollDirection == .horizontal {
                offset = CGPoint(x: (self.bounds.width * CGFloat(self.data.count - 2)) - self.edgeInsets.left, y: -self.edgeInsets.top)
            } else {
                offset = CGPoint(x: -self.edgeInsets.left, y: (self.bounds.height * CGFloat(self.data.count - 2)) - self.edgeInsets.top)
            }
            self.collectionView.contentOffset = offset
        }
    }
    
    private func checkPage() {
        if currentIndex == data.count - 1 {
            scrollToFirstDataOnMain()
        }
        if currentIndex == 0 {
            scrollToLastDataOnMain()
        }
    }
}

extension CHBannerView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BannerCollectionViewCell! = collectionView.dequeueReusableCell(indexPath: indexPath)
        if let banner = data[indexPath.item] as? CHBanner {
            cell.setCell(data: banner)
        }
        if let customView = data[indexPath.item] as? UIView {
            cell.setCell(data: customView)
        }
        cell.setCellStyle(itemStyle)
        return cell
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard isAutoRotation else {
            timer?.invalidate()
            timer = nil
            return
        }
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScrollAction), userInfo: nil, repeats: true)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkPage()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionView.isUserInteractionEnabled = true
        delegate?.bannerViewDidEndScroll(self, current: currentIndex)
        checkPage()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = indexPath.item - 1
        if currentIndex == data.count - 1 {
            index = 0
        }
        if currentIndex == 0 {
            index = data.count - 3
        }
        delegate?.bannerView(self, didSelectItemAt: index)
        if let b = didSelectItem {
            b(self, index)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard bounds.width > 0 else { return }
        if scrollDirection == .horizontal {
            currentIndex = Int((scrollView.contentOffset.x + edgeInsets.left) / bounds.width)
        } else {
            currentIndex = Int((scrollView.contentOffset.y + edgeInsets.top) / bounds.height)
        }
    }
}

class CHBannerFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        /// 建议的点（在集合视图的内容视图中），在该点停止滚动。这是如果不进行任何调整自然会停止滚动的值。该点反映了可见内容的左上角。
        
        guard let collectionView = collectionView else {
            return .zero
        }
        if scrollDirection == .horizontal {
            let pageWidth = self.itemSize.width + self.minimumInteritemSpacing

            let approximatePage = collectionView.contentOffset.x / pageWidth

            let currentPage = velocity.x == 0 ? round(approximatePage) : (velocity.x < 0.0 ? floor(approximatePage) : ceil(approximatePage))

            let flickVelocity = velocity.x * 0.3

            let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)

            let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - collectionView.contentInset.left

            return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
        } else {
            // Page height used for estimating and calculating paging.
            let pageHeight = self.itemSize.height + self.minimumLineSpacing

            // Make an estimation of the current page position.
            let approximatePage = collectionView.contentOffset.y / pageHeight

            // Determine the current page based on velocity.
            let currentPage = velocity.y == 0 ? round(approximatePage) : (velocity.y < 0.0 ? floor(approximatePage) : ceil(approximatePage))

            // Create custom flickVelocity.
            let flickVelocity = velocity.y * 0.3

            // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
            let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)

            let newVerticalOffset = ((currentPage + flickedPages) * pageHeight) - collectionView.contentInset.top

            return CGPoint(x: proposedContentOffset.x, y: newVerticalOffset)
        }
        
        // MARK: - 这里的方法也有效，上面的更优雅
//        let index = (proposedContentOffset.x + collectionView.contentInset.left) / collectionView.frame.width
//        print(index)
//        var offsetX: CGFloat = 0
//        if index.truncatingRemainder(dividingBy: 1) >= 0.5 { // 余数大于 0.5 滚到下一页
//            print("next: \(index.truncatingRemainder(dividingBy: 1))")
//            let next = index + 1
//            offsetX = collectionView.frame.width * CGFloat(Int(next))
//        } else { // 余数小于0.5，则滚回当前页的初始位置
//            offsetX = collectionView.frame.width * CGFloat(Int(index))
//            print("current: \(index.truncatingRemainder(dividingBy: 1))")
//
//        }
//        return CGPoint(x: offsetX - collectionView.contentInset.left, y: proposedContentOffset.y)
    }
    
}

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
