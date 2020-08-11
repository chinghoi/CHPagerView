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
    public var edgeInsets: UIEdgeInsets {
        set { collectionView.contentInset = newValue }
        get { collectionView.contentInset }
    }
    
    /// Default is 0.
    public var minimumItemSpacing: CGFloat {
        set {
            layout.minimumLineSpacing = newValue
        }
        get {
            layout.minimumLineSpacing
        }
    }
    
    /// Constants indicating the direction of scrolling for the layout.
    /// Default is horizontal.
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
    
//    /// Is endless.
//    /// Default is true
//    public var isEndless: Bool = true
    
    public var itemStyle = CHBannerItemStyle() { didSet { collectionView.reloadData() } }
    
    public override var backgroundColor: UIColor? {
        set { collectionView.backgroundColor = newValue }
        get { collectionView.backgroundColor }
    }
    
    public var backgroundView: UIView? {
        set { collectionView.backgroundView = newValue }
        get { collectionView.backgroundView }
    }
    
    
    // MARK: - Private
    
    private var currentIndex: Int = 1
    private var itemAddSpacing: CGFloat {
        if scrollDirection == .horizontal {
            return layout.itemSize.width + layout.minimumLineSpacing
        } else {
            return layout.itemSize.height + layout.minimumLineSpacing
        }
    }
    private var timer: Timer?
    /// 传入的数据的基础上 ，首部加入了最后一个数据， 尾部加入了第一个数据。该数据总长度为 原数据 + 2
    private var data: [Any] = []
    private var indexArr: [Int] = []
    private var layout = CHBannerFlowLayout()
    
    private lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        v.register(CHBannerCollectionViewCell.self, forCellWithReuseIdentifier: "CHBannerCollectionViewCell")
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
        collectionView.frame = self.bounds
        collectionView.contentInset = edgeInsets
        
        layout.itemSize = collectionView.bounds.inset(by: edgeInsets).size
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    public func setData(data: [CHBanner]) {
        setData(any: data)
    }
    
    public func setData(data: [UIView]) {
        setData(any: data)
    }
    
    private func setData(any: [Any]) {
//        guard any.count >= 1, let last = any.last, let first = any.first else { return }
//        self.data = [last] + any + [first]
        indexArr = []
        self.data = any
        for _ in 0 ..< 100 {
            for j in 0 ..< data.count {
                indexArr.append(j)
            }
        }
        collectionView.reloadData()
        DispatchQueue.main.async {
//            if self.scrollDirection == .horizontal {
//                self.collectionView.contentOffset = CGPoint(x: self.itemAddSpacing - self.edgeInsets.left, y: -self.edgeInsets.top)
//            } else {
//                self.collectionView.contentOffset = CGPoint(x: -self.edgeInsets.left, y: self.itemAddSpacing - self.edgeInsets.top)
//            }
            self.scrollToItemFor(index: 50 * any.count, animated: false)
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
//        if currentIndex == indexArr.count - 1 {
//            scrollToFirstDataOnMain()
//        }
        DispatchQueue.main.async {
            self.scrollToItemFor(index: self.currentIndex + 1, animated: true)
            self.collectionView.isUserInteractionEnabled = false
        }
    }
//    private func scrollToFirstDataOnMain() {
//        DispatchQueue.main.async {
//            let offset: CGPoint
//            if self.scrollDirection == .horizontal {
//                offset = CGPoint(x: self.itemAddSpacing - self.edgeInsets.left, y: -self.edgeInsets.top)
//            } else {
//                offset = CGPoint(x: -self.edgeInsets.left, y: self.itemAddSpacing - self.edgeInsets.top)
//            }
//            self.collectionView.contentOffset = offset
//        }
//    }
//    private func scrollToLastDataOnMain() {
//        DispatchQueue.main.async {
//            let offset: CGPoint
//            if self.scrollDirection == .horizontal {
//                offset = CGPoint(x: (self.itemAddSpacing * CGFloat(self.data.count - 2)) - self.edgeInsets.left, y: -self.edgeInsets.top)
//            } else {
//                offset = CGPoint(x: -self.edgeInsets.left, y: (self.itemAddSpacing * CGFloat(self.data.count - 2)) - self.edgeInsets.top)
//            }
//            self.collectionView.contentOffset = offset
//        }
//    }
    
    private func scrollToItemFor(index: Int, animated: Bool) {
        let nextOffset: CGPoint
        if self.scrollDirection == .horizontal {
            nextOffset = CGPoint(x: CGFloat(index) * self.itemAddSpacing - self.edgeInsets.left, y: -self.edgeInsets.top)
        } else {
            nextOffset = CGPoint(x: -self.edgeInsets.left, y: CGFloat(index) * self.itemAddSpacing - self.edgeInsets.top)
        }
        self.collectionView.setContentOffset(nextOffset, animated: animated)
    }
    
//    private func checkPage() {
//        if currentIndex == indexArr.count - 1 {
//            scrollToFirstDataOnMain()
//        }
//        if currentIndex == 0 {
//            scrollToLastDataOnMain()
//        }
//    }
}

extension CHBannerView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CHBannerCollectionViewCell", for: indexPath) as! CHBannerCollectionViewCell
        
        let index = indexArr[indexPath.row]
        let item = data[index]
        if let banner = item as? CHBanner {
            cell.setCell(data: banner)
        }
        if let customView = item as? UIView {
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
        self.scrollToItemFor(index: 50 * data.count + (currentIndex % data.count), animated: false)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionView.isUserInteractionEnabled = true
        let index = currentIndex % data.count
        delegate?.bannerViewDidEndScroll(self, current: index)
        self.scrollToItemFor(index: 50 * data.count + (currentIndex % data.count), animated: false)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item % data.count
        delegate?.bannerView(self, didSelectItemAt: index)
        if let b = didSelectItem {
            b(self, index)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.itemAddSpacing > 0 else { return }
        if scrollDirection == .horizontal {
            currentIndex = Int((scrollView.contentOffset.x + edgeInsets.left) / self.itemAddSpacing)
        } else {
            currentIndex = Int((scrollView.contentOffset.y + edgeInsets.top) / self.itemAddSpacing)
        }
    }
}
