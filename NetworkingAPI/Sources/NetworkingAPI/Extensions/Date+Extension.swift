//
//  Date+Extension.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/18/25.
//
import Foundation

extension Date {
    func convertToLocalTime() -> Date {
        let timezoneOffset = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        return addingTimeInterval(timezoneOffset)
    }
}
