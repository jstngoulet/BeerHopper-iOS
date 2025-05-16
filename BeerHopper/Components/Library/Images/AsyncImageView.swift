//
//  AsyncImageView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//

import SwiftUI
import Combine

/**
 Custom Async Image view to show use of custom caching, instead of AsyncImage.
 AsyncImage uses default NSURLSession caching, so we want to showcase how we can
 achieve a similar goal in a simple way, using an NSCache in front of the request.
 */
struct AsyncImageView: View {
    
    /// the remote url string, that will later be converted to a url for loading
    @State
    private var url: String
    
    /// The placeholder image, presented in the view
    /// - Note: This image is updated once the image is downloaded
    ///         from the image loader
    @State
    private var placeholder: Image
    
    /// The model for the class, updates the image view
    /// when a new image is found
    @ObservedObject
    private var imageLoader: ImageLoader
    
    /// Init the image view with a url and placeholder. This info will be passed
    /// to the image loader and automatically updated in the view
    /// - Parameters:
    ///   - url:            The URL of the remote image
    ///   - placeholder:    The placeholder image to use while the image is loading
    public init(
        url: String,
        placeholder: Image
    ) {
        self.url = url
        self.placeholder = placeholder
        self.imageLoader = ImageLoader(
            source: ImageSource.unfetched(
                url: URL(string: url)
            ), placeholder: placeholder
        )
    }
    
    /// Create the custom image view
    public var body: some View {
        placeholder
            .resizable()
            .onReceive(imageLoader.$imageSource) { newSource in
                self.placeholder = newSource.image ?? self.placeholder
            }
    }
    
}

#Preview {
    AsyncImageView(
        url: "https://picsum.photos/300",
        placeholder: Image(systemName: "photo")
    )
}
