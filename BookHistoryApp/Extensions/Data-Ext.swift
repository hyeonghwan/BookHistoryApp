//
//  Data-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/29.
//

import Foundation

extension Date {
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
   public var isSunday: Bool {
        let sunday = Date(timeIntervalSince1970: 1663475400)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self) == dateFormatter.string(from: sunday)
    }
    
    public var isSaturday: Bool {
        let saturday = Date(timeIntervalSince1970: 1663389000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self) == dateFormatter.string(from: saturday)
    }
}
