//
//  Extension.swift
//  PSL-RedditApp
//
//  Created by PSL on 12/05/20.
//  Copyright © 2020 PSL All rights reserved.
//

import Foundation
import UIKit

extension String {
    // MARK: - Get decode url
    init?(htmlEncodedString: String) {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString.string)
    }
}

extension UIView {
    // MARK: - Individual Constraints
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                topConstant: CGFloat = 0,
                bottom: NSLayoutYAxisAnchor? = nil,
                bottomConstant: CGFloat = 0,
                leading: NSLayoutXAxisAnchor? = nil,
                leadingConstant: CGFloat = 0,
                trailing: NSLayoutXAxisAnchor? = nil,
                trailingConstant: CGFloat = 0,
                centerX: NSLayoutXAxisAnchor? = nil,
                centerXConstant: CGFloat = 0,
                centerY: NSLayoutYAxisAnchor? = nil,
                centerYConstant: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let topAnchor = top {
            self.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        }
        if let bottomAnchor = bottom {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomConstant).isActive = true
        }
        if let leadingAnchor = leading {
            self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant).isActive = true
        }
        if let trailingAnchor = trailing {
            self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingConstant).isActive = true
        }
        if let centerXAnchor = centerX {
            self.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerXConstant).isActive = true
        }
        if let centerYAnchor = centerY {
            self.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYConstant).isActive = true
        }
    }
}

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}
// MARK: - To get kFormat (1000 = 1k)
func formatNumber(_ n: Int) -> String {
    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""

    switch num {
    case 1_000_000_000...:
        var formatted = num / 1_000_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)B"

    case 1_000_000...:
        var formatted = num / 1_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)M"

    case 1_000...:
        var formatted = num / 1_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)K"

    case 0...:
        return "\(n)"

    default:
        return "\(sign)\(n)"
    }
}
