//
//  ScreenState.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//


enum ScreenState<T> {
    case pending
    case loading
    case noResults
    case loaded(T)
    case error(Error)
}
