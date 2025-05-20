//
//  Dictionary+Extension.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import Foundation

extension Dictionary where Key == String, Value == Any? {
    func toQueryString() -> String {
        self.compactMap { key, value in
            guard let value = value else { return nil }
            
            let stringValue: String
            switch value {
            case let str as String:
                stringValue = str
            case let num as NSNumber:
                stringValue = num.stringValue
            case let int as Int:
                stringValue = String(int)
            case let double as Double:
                stringValue = String(double)
            default:
                return nil // Skip unsupported types
            }
            
            let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "\(escapedKey)=\(escapedValue)"
        }
        .joined(separator: "&")
    }
}
