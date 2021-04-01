//
//  CHLoadImage.swift
//  CHPagerView
//
//  Created by chinghoi on 2021/3/19.
//

import Foundation

extension UIImageView {
    
    func loadWith(url: String) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, respons, error) in
            print(error as Any)
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                   self.image = image
                }
            }
        }
        dataTask.resume()
    }
}
