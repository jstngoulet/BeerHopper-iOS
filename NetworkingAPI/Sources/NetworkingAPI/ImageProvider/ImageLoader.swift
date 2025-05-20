//
//  ImageLoader.swift.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import UIKit
import SwiftUI

actor ImageCache {
    
    private let cache: NSCache<NSString, UIImage> = {
        let cache: NSCache<NSString, UIImage> = NSCache()
        cache.countLimit = 1_000
        return cache
    }()
    
    func get(forKey key: NSString) -> UIImage? {
        cache.object(forKey: key)
    }
    
    func set(_ image: UIImage, forKey key: NSString) {
        cache.setObject(image, forKey: key)
    }
    
    func clear() {
        cache.removeAllObjects()
    }
}

public actor ImageLoaderActor {
    
    public enum ImageLoaderError: LocalizedError {
        case invalidSource
        case invalidImageData(Data)
        case taskCancelled
    }
    
    private var cache = NSCache<NSString, UIImage>()
    
    public init() {
        cache.countLimit = 1_000
    }
    
    public func load(from url: URL, retryCount: Int = 0) async -> Result<UIImage, Error> {
        // Cache check
        if let cached = cache.object(forKey: url.absoluteString as NSString) {
            return .success(cached)
        }
        
        var attempts = 0
        
        while attempts <= retryCount {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if Task.isCancelled {
                    return .failure(ImageLoaderError.taskCancelled)
                }
                
                guard let image = UIImage(data: data) else {
                    return .failure(ImageLoaderError.invalidImageData(data))
                }
                
                cache.setObject(image, forKey: url.absoluteString as NSString)
                return .success(image)
            } catch {
                if attempts == retryCount {
                    return .failure(error)
                }
                attempts += 1
            }
        }
        
        return .failure(ImageLoaderError.taskCancelled)
    }
    
    public func clearCache() {
        cache.removeAllObjects()
    }
}

@MainActor
public class ImageLoader: ObservableObject {
    
    @Published
    public var imageSource: ImageSource    = .placeholder(image: nil)
    
    private var currentTask: Task<Void, Never>?
    private let imageLoader: ImageLoaderActor
    
    public init(
        imageSource: ImageSource,
        imageLoader: ImageLoaderActor = .init(),
        placeholder: Image? = nil
    ) {
        self.imageSource = .placeholder(image: placeholder)
        self.imageLoader = imageLoader
        self.load(source: imageSource)
    }
    
    func load(source: ImageSource) {
        currentTask?.cancel()
        currentTask = Task {
            guard case let .unfetched(url) = source
                    , let url
                else { return }
            let imageResult = await imageLoader.load(from: url)
            
            switch imageResult {
            case .success(let img):
                await MainActor.run {
                    self.imageSource = .fetched(image: Image(uiImage: img))
                }
            case .failure(let err):
                await MainActor.run {
                    self.imageSource = .error(err)
                }
            }
        }
    }
    
    func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    deinit {
        currentTask?.cancel()
        currentTask = nil
    }
}

/**
import SwiftUI

public class ImageLoader: ObservableObject {
    
    enum ImageLoaderError: LocalizedError {
        case invalidSource(source: ImageSource)
        case taskCancelled
        case invalidImageData(Data)
    }
    
    @Published
    var imageSource: ImageSource
    
    @MainActor
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
    
}*/
