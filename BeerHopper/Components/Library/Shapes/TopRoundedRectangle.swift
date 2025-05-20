//
//  TopRoundedRectangle.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//
import SwiftUI

struct TopRoundedRectangle: Shape {
    
    var radius: CGFloat
    var corners: UIRectCorner = [.topLeft, .topRight]
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
    
    init(radius: CGFloat, corners: UIRectCorner) {
        self.radius = radius
        self.corners = corners
    }
    
    init (radius: CGFloat) {
        self.radius = radius
    }
    
}
