//
//  SwiftUICustomTagListView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//
import SwiftUI

/// A SwiftUI view that presents a customizable tag list.
public struct SwiftUICustomTagListView<Content: View>: View {
    
    /// An array of Tag View
    private let tagViews: [SwiftUICustomTagView<Content>]
    /// Horizontal space between each tag
    private let horizontalSpace: CGFloat
    /// Vertical space between each tag
    private let verticalSpace: CGFloat
    
    @State private var listHeight: CGFloat = 0
    
    public init(_ views: [SwiftUICustomTagView<Content>],
                horizontalSpace: CGFloat,
                verticalSpace: CGFloat) {
        self.tagViews = views
        self.horizontalSpace = horizontalSpace
        self.verticalSpace = verticalSpace
    }
    
    public var body: some View {
        GeometryReader { geometry in
            generateTags(geometry, views: tagViews)
                .background(GeometryReader { geo in
                    Color(.clear)
                        .onAppear {
                            self.listHeight = geo.size.height
                        }
                })
        }
        .frame(height: listHeight)
    }
    
    // ref: https://reona.dev/posts/20200929
    private func generateTags(_ geometry: GeometryProxy,
                              views: [SwiftUICustomTagView<Content>]) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(views, id: \.self) { view in
                view
                    .padding(.trailing, horizontalSpace)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height + verticalSpace
                        }
                        let result = width
                        if view == views.last {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { dimension in
                        let result = height
                        if view == views.last {
                            height = 0
                        }
                        return result
                    })
            }
        }
    }
}
