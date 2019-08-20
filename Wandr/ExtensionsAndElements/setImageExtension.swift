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
    
    func setImage(urlstring: String, size: CGSize, complete: @escaping () -> ()) {
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
}
