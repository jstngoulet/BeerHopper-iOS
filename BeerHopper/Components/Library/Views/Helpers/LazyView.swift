//
//  LazyView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    var body: some View { build() }
}
