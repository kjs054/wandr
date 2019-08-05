//
//  downloadCacheDisplayImage.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/27/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

private var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageWithCacheFromURLString(urlstring: String, complete: @escaping () -> ()) {
        
        if let imageFromCache = imageCache.object(forKey: urlstring as AnyObject) as? UIImage {
            self.image = imageFromCache
            complete()
        }
        
        let url = URL(string: urlstring)
        URLSession.shared.dataTask(with: url!) { //Downloads the image from the provided url parameter
            data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: data) {
                        imageCache.setObject(imageToCache, forKey: urlstring as AnyObject) //Cache the image
                        self.image = imageToCache //Make the imageview image display downloaded image
                        complete()
                    }
                }
            }
            }.resume() //If suspended
    }
}
