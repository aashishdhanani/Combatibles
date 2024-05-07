//
//  util.swift
//  combatible
//
//  Created by Aiden Seibel on 4/20/24.
//

import Foundation

func timeSince(date: Date) -> String {
    let currentDate = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: currentDate)
    
    if let years = components.year, years > 0 {
        return "\(years) years"
    } else if let months = components.month, months > 0 {
        return "\(months) months"
    } else if let days = components.day, days > 0 {
        return "\(days) days"
    } else if let hours = components.hour, hours > 0 {
        return "\(hours) hours"
    } else if let minutes = components.minute, minutes > 0 {
        return "\(minutes) minutes"
    } else if let seconds = components.second, seconds > 0 {
        return "\(seconds) seconds"
    } else {
        return "just now"
    }
}


func getRandomLatitude() -> Double{
    return Double.random(in: 29.44...29.47)
}

func getRandomLongitude() -> Double{
    return Double.random(in: (-98.50)...(-98.47))
}
