//
//  ImageSource.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//

import SwiftUI
/**
 Image Source for the Image Provider
 */
enum ImageSource: Equatable {
    
    /// Compares the images, as the actual source doesn't matter for our current use
    /// - Parameters:
    ///   - lhs: The lhs comparator
    ///   - rhs: The rhs comparator
    /// - Returns: Whether the images are equal or not
    static func == (lhs: ImageSource, rhs: ImageSource) -> Bool {
        lhs.image == rhs.image
    }
    
    /// When the image is not yet fetched from a server
    case unfetched(url: URL?)
    
    /// When the image is fetched sucessfully
    case fetched(image: Image)
    
    /// When the image is just returned from the cache
    case cached(image: Image)
    
    /// When the source is just diaplying a placeholder
    case placeholder(image: Image?)
    
    /// When there was an error loading the image
    case error(Error)
    
    /// Based on the various image sources, display the image
    var image: Image? {
        return switch self {
        case .unfetched:                nil
        case .fetched(let image):       image
        case .cached(let image):        image
        case .placeholder(let image):   image
        case .error:                    nil
        }
    }
}
