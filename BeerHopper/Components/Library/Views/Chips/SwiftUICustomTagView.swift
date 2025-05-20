//
//  SwiftUICustomTagView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//
import SwiftUI

public struct SwiftUICustomTagView<Content: View>: View, Hashable {
    
    private let id = UUID()
    @State private var content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        _content = State(initialValue: content())
    }
    
    public var body: some View {
        content
    }
    
    public static func == (lhs: SwiftUICustomTagView, rhs: SwiftUICustomTagView) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
