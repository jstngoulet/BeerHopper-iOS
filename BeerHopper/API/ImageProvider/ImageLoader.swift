//
//  ImageLoader.swift.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//

import SwiftUI

class ImageLoader: ObservableObject {
    
    enum ImageLoaderError: LocalizedError {
        case invalidSource(source: ImageSource)
        case taskCancelled
        case invalidImageData(Data)
    }
    
    @Published var imageSource: ImageSource
    
    private static var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 1_000
        return cache
    }()
    
    private var currentTask: Task<Void, Never>?
    
    init(source: ImageSource, placeholder: Image? = nil) {
        if placeholder == nil {
            imageSource = .placeholder(image: placeholder)
        } else {
            imageSource = source
        }
        
        //  Load the image
        currentTask = Task { @MainActor in
            self.imageSource = await self.load(source)
        }
    }
    
    init() {
        imageSource = .placeholder(image: nil)
    }
    
    deinit {
        cancel()
    }
    
    func load(_ source: ImageSource, retryCount: Int = 0) async -> ImageSource {
        guard source.image == nil else { return source }
        guard case let .unfetched(url) = source, let url else {
            return source
        }
        
        // Return from cache if possible
        if let cached = ImageLoader.imageCache.object(forKey: url.absoluteString as NSString) {
            return .fetched(image: Image(uiImage: cached))
        }
        
        var attempts = 0
        while attempts <= retryCount {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if Task.isCancelled {
                    return .error(ImageLoaderError.taskCancelled)
                }
                
                guard let image = UIImage(data: data) else {
                    return .error(ImageLoaderError.invalidImageData(data))
                }
                
                ImageLoader.imageCache.setObject(
                    image,
                    forKey: url.absoluteString as NSString
                )
                return .fetched(image: Image(uiImage: image))
            } catch {
                if attempts == retryCount {
                    return .error(error)
                }
                attempts += 1
            }
        }
        
        return .error(ImageLoaderError.taskCancelled)
    }
    
    func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }
    
}
