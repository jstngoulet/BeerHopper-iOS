//
//  BlurView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/21/25.
//
import SwiftUI

struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
}
