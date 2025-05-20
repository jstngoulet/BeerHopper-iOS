//
//  JSONDecoder+Date+Extension.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/16/25.
//
import Foundation

extension JSONDecoder.DateDecodingStrategy {
    
    static let iso8601WithFractionalAndFallback: JSONDecoder.DateDecodingStrategy = .custom { decoder -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",  // With milliseconds
            "yyyy-MM-dd'T'HH:mm:ssZ"       // Without milliseconds
        ]
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)  // Expecting UTC input
        
        for format in formats {
            formatter.dateFormat = format
            if let utcDate = formatter.date(from: dateString) {
                return utcDate.convertToLocalTime()
            }
        }
        
        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Date string does not match expected formats: \(formats.joined(separator: ", "))"
        )
    }
}


