//
//  ViewController.swift
//  CHPagerView
//
//  Created by Chinghoi on 08/10/2020.
//  Copyright (c) 2020 Chinghoi. All rights reserved.
//

import UIKit
import CHPagerView

class ViewController: UIViewController {
    
    private lazy var bannerViewOne: CHPagerView = {
        let b = CHPagerView()
        b.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 100)
        b.minimumItemSpacing = 25
        b.backgroundColor = .lightGray
        b.didSelectItem = { [weak self] pagerView, index in
            print("Did selected item in \(index)")
        }
        b.isEndless = false
        return b
    }()
    
    private lazy var bannerViewTwo: CHPagerView = {
        let b = CHPagerView()
        b.delegate = self
        return b
    }()

    private lazy var bannerViewThree: CHPagerView = {
        let b = CHPagerView()
        b.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        b.backgroundColor = .lightGray
        b.scrollDirection = .vertical
        b.minimumItemSpacing = 40
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bannerViewOne)
        view.addSubview(bannerViewTwo)
        view.addSubview(bannerViewThree)
        
        bannerViewOne.frame = CGRect(x: 0, y: 40, width: 375, height: 200)
        bannerViewTwo.frame = CGRect(x: 0, y: 250, width: 375, height: 200)
        bannerViewThree.frame = CGRect(x: 0, y: 460, width: 375, height: 200)
        
        let images = [UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!]
        bannerViewOne.setData(images)

        let customViews: [UIView] = [UIColor.red, UIColor.yellow, UIColor.green].map {
            let v = UIView()
            v.backgroundColor = $0
            return v
        }
        bannerViewTwo.setData(customViews)

        let urls = ["https://github.com/chinghoi/CHPagerView/blob/master/png1.png", "https://github.com/chinghoi/CHPagerView/blob/master/png2.png"]
        bannerViewThree.setData(urls, placeholder: UIImage(named: "placeholder"))
    }
}

extension ViewController: CHPagerViewDelegate {
    
    func pagerView(_ bannerView: CHPagerView, didSelectItemAt index: Int) {
        print("didSelectItemAt \(index)")
    }
    func pagerViewDidEndScroll(_ bannerView: CHPagerView, current index: Int) {
        print("Banner view did end scroll in \(index)")
    }
}
