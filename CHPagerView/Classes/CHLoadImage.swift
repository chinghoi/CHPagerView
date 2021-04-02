//
//  CHLoadImage.swift
//  CHPagerView
//
//  Created by chinghoi on 2021/3/19.
//

import Foundation

var cacheImage = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadWith(url: String, placeholder: UIImage?) {
        
        let data = cacheImage.object(forKey: url as AnyObject) as? Data
        guard data == nil else {
            let image = UIImage(data: data!)
            self.image = image
            return
        }
        
        guard let u = URL(string: url) else {
            print("CHERROR => URL invalid")
            return
        }
        DispatchQueue.main.async { [weak self] in
           self?.image = placeholder
        }
        
        let dataTask = URLSession.shared.dataTask(with: u) { (data, respons, error) in
            if let data = data, error == nil {
                if let image = UIImage(data: data) {
                    cacheImage.setObject(data as AnyObject, forKey: url as AnyObject)
                    DispatchQueue.main.async { [weak self] in
                       self?.image = image
                    }
                } else {
                    print("CHERROR => Failed to parse image: \(data)")
                }
                
            } else {
                print("CHERROR => Failed to parse image error: \(error?.localizedDescription ?? "data is nil")")
            }
        }
        dataTask.resume()
    }
}
