//
//  AnyShape.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//

import SwiftUI

struct AnyShape: Shape, @unchecked Sendable {
        
    private let pathFunction: (CGRect) -> Path
    
    init<S: Shape>(_ wrapped: S) {
        self.pathFunction = { rect in
            wrapped.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        pathFunction(rect)
    }
}
