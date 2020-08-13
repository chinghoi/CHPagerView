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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let oneData = [CHBanner(image: UIImage(named: "1")), CHBanner(image: UIImage(named: "2")), CHBanner(image: UIImage(named: "3"))]
        bannerViewOne.setData(data: oneData)
        
        let twoData: [UIView] = [UIColor.red, UIColor.yellow, UIColor.green].map {
            let v = UIView()
            v.backgroundColor = $0
            return v
        }
        bannerViewTwo.setData(data: twoData)
        
        let threeData: [UIView] = [UIColor.red, UIColor.yellow, UIColor.green].map {
            let v = UIView()
            v.backgroundColor = $0
            return v
        }
        let appendView = UIImageView(image: UIImage(named: "1"))
        appendView.contentMode = .scaleAspectFill
        appendView.clipsToBounds = true
        bannerViewThree.setData(data: threeData + [appendView])
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
