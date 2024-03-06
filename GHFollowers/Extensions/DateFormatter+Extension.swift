//
//  DateFormatter+Extension.swift
//  GHFollowers
//
//  Created by winsen on 01/03/24.
//

import Foundation

extension DateFormatter {
    static var monthYearDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter
    }
}
