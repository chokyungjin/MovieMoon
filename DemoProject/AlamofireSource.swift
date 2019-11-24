//
//  AlamofireSource.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 14.01.16.
//
//

import Alamofire
import AlamofireImage

/// Input Source to image using Alamofire
@objcMembers
public class AlamofireSource: NSObject {
    /// url to load
    public var url: URL
    
    /// placeholder used before image is loaded
    public var placeholder: UIImage?

    /// Initializes a new source with a URL
    /// - parameter url: a url to load
    /// - parameter placeholder: a placeholder used before image is loaded
    public init(url: URL, placeholder: UIImage? = nil) {
        self.url = url
        self.placeholder = placeholder
        super.init()
    }

    /// Initializes a new source with a URL string
    /// - parameter urlString: a string url to load
    /// - parameter placeholder: a placeholder used before image is loaded
    public init?(urlString: String, placeholder: UIImage? = nil) {
        if let validUrl = URL(string: urlString) {
            self.url = validUrl
            self.placeholder = placeholder
            super.init()
        } else {
            return nil
        }
    }

    public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        imageView.af_setImage(withURL: self.url, placeholderImage: placeholder, filter: nil, progress: nil) { [weak self] (response) in                                                              
            if response.result.isSuccess {
                callback(response.result.value)
            } else if let strongSelf = self {
                callback(strongSelf.placeholder)
            } else {
                callback(nil)
            }                                                                                                 
        }
    }

    public func cancelLoad(on imageView: UIImageView) {
        imageView.af_cancelImageRequest()
    }
}
