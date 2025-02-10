//
//  UIImageView+ImageCache.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String, placeholder: UIImage? = nil) {
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    DispatchQueue.main.async {
                        self.image = image.resizeKeepRatio(newWidth: self.bounds.width)
                    }
                } else {
                    guard let url = URL(string: urlString) else { return }
                    let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
                    DispatchQueue.main.async {
                        self.kf.setImage(with: resource, placeholder: placeholder)
                    }
                }
            case .failure(let error):
                dump(error)
            }
        }
    }
}
