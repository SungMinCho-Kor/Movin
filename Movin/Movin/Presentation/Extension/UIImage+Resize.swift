//
//  UIImage+Resize.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

extension UIImage {
    func resizeKeepRatio(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(
                in: CGRect(
                    origin: .zero,
                    size: size
                )
            )
        }
        return renderImage
    }
    
    func resizeKeepRatio(newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(
                in: CGRect(
                    origin: .zero,
                    size: size
                )
            )
        }
        return renderImage
    }
    
    func resize(newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(
                in: CGRect(
                    origin: .zero,
                    size: size
                )
            )
        }
        return renderImage
    }
}
