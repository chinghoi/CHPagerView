//
//  CHPagerView
//
//  Created by chinghoi on 2020/8/10.
//

import UIKit
import AlamofireImage

/// PagerView, support set to UIView array, or default Banner class array.
public class CHPagerView: UIView {
    
    public weak var delegate: CHPagerViewDelegate?
    public var didSelectItem: ((_ pagerView: CHPagerView, _ index: Int) -> Void)?
    
    // MARK: - Public
    public var contentInset: UIEdgeInsets {
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
    public var isAutoRotation: Bool = true {
        didSet {
            timer?.invalidate()
            timer = nil
        }
    }
    
    /// Is endless.
    /// Default is true
    public var isEndless: Bool = true
    
    public var itemStyle = CHPagerItemStyle() { didSet { collectionView.reloadData() } }
    
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
    private var data: [Any] = [] {
        didSet {
            if data.count <= 1 {
                isAutoRotation = false
                isEndless = false
            }
        }
    }
    private var indexArr: [Int] = []
    private var layout = CHPagerFlowLayout()
    
    private lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        v.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CHPagerViewDefaultCell")
        v.register(CHPagerCollectionViewCell.self, forCellWithReuseIdentifier: "CHPagerCollectionViewCell")
        v.register(CHPagerCustomCollectionViewCell.self, forCellWithReuseIdentifier: "CHPagerCustomCollectionViewCell")
        v.bounces = false
        v.isPagingEnabled = false
        v.decelerationRate = .fast
        v.dataSource = self
        v.delegate = self
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
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
        collectionView.contentInset = contentInset
        
        layout.itemSize = collectionView.bounds.inset(by: contentInset).size
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    public func setData(data: [CHBanner]) {
        setData(any: data)
    }
    
    public func setData(data: [UIView]) {
        setData(any: data)
    }
    
    private func setData(any: [Any]) {
        indexArr = []
        self.data = any
        
        if isEndless {
            for _ in 0 ..< 100 {
                for j in 0 ..< data.count {
                    indexArr.append(j)
                }
            }
        } else {
            for j in 0 ..< data.count {
                indexArr.append(j)
            }
        }
        
        collectionView.reloadData()
        DispatchQueue.main.async {
            self.scrollToItemFor(index: (self.isEndless ? 50 : 0) * any.count, animated: false)
        }

        stopTimer()
        guard isAutoRotation else { return }
        startTimer()
    }
    
    private func startTimer() {
      if timer == nil {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScrollAction), userInfo: nil, repeats: true)
      }
    }

    private func stopTimer() {
      if timer != nil {
        timer!.invalidate()
        timer = nil
      }
    }
    
    @objc
    private func autoScrollAction() {
        DispatchQueue.main.async {
            var nextIndex: Int = 0
            if self.isEndless {
                nextIndex = self.currentIndex + 1
            } else {
                if self.currentIndex + 1 >= self.data.count {
                    nextIndex = 0
                } else {
                    nextIndex = self.currentIndex + 1
                }
            }
            self.scrollToItemFor(index: nextIndex, animated: true)
            self.collectionView.isUserInteractionEnabled = false
        }
    }
    
    private func scrollToItemFor(index: Int, animated: Bool) {
        let nextOffset: CGPoint
        if self.scrollDirection == .horizontal {
            nextOffset = CGPoint(x: CGFloat(index) * self.itemAddSpacing - self.contentInset.left, y: -self.contentInset.top)
        } else {
            nextOffset = CGPoint(x: -self.contentInset.left, y: CGFloat(index) * self.itemAddSpacing - self.contentInset.top)
        }
        self.collectionView.setContentOffset(nextOffset, animated: animated)
    }
    
}

extension CHPagerView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexArr[indexPath.row]
        let item = data[index]
        if let customView = item as? UIView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CHPagerCustomCollectionViewCell", for: indexPath) as! CHPagerCustomCollectionViewCell
            cell.setCell(customView: customView)
            return cell
        } else if let banner = item as? CHBanner {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CHPagerCollectionViewCell", for: indexPath) as! CHPagerCollectionViewCell
            cell.setCell(data: banner)
            cell.setCellStyle(itemStyle)
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "CHPagerViewDefaultCell", for: indexPath)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard isAutoRotation else {
            stopTimer()
            return
        }
        startTimer()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = currentIndex % data.count
        delegate?.pagerViewDidEndScroll(self, current: index)
        self.scrollToItemFor(index: (self.isEndless ? 50 : 0) * data.count + (currentIndex % data.count), animated: isEndless ? false : true)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionView.isUserInteractionEnabled = true
        let index = currentIndex % data.count
        delegate?.pagerViewDidEndScroll(self, current: index)
        self.scrollToItemFor(index: (self.isEndless ? 50 : 0) * data.count + (currentIndex % data.count), animated: isEndless ? false : true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item % data.count
        delegate?.pagerView(self, didSelectItemAt: index)
        if let b = didSelectItem {
            b(self, index)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.itemAddSpacing > 0 else { return }
        if scrollDirection == .horizontal {
            currentIndex = Int((scrollView.contentOffset.x + contentInset.left) / self.itemAddSpacing)
        } else {
            currentIndex = Int((scrollView.contentOffset.y + contentInset.top) / self.itemAddSpacing)
        }
    }
}
