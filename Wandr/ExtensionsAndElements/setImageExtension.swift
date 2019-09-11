//
//  downloadCacheDisplayImage.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/27/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import Kingfisher

private var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func setCachedImage(urlstring: String, size: CGSize, complete: @escaping () -> ()) {
        let processor = ResizingImageProcessor(referenceSize: size)
        self.kf.setImage(
            with: URL(string: urlstring),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(2)),
                .cacheOriginalImage
            ])
        complete()
    }
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
