//
//  File.swift
//  
//
//  Created by Mayur Dhaka on 04/04/20.
//

import Foundation
import DHTTimer

public struct ToothbrushEventVD {
    public let id: UUID
    public let duration: SmallTime
    public let startDate: Date
    
    public init(
        id: UUID,
        duration: SmallTime,
        startDate: Date
    ) {
        self.id = id
        self.duration = duration
        self.startDate = startDate
    }
    
    public init(
        id: UUID,
        startDate: Date,
        endDate: Date
    ) throws {
        self.id = id
        self.startDate = startDate
        duration = try SmallTime(
            timeInterval: endDate.timeIntervalSince(startDate)
        )
    }
    
    public func localisedStartTime() -> String {
        // Not localised for now
        let time = Calendar.current.dateComponents(
            [.hour, .minute], from: startDate
        )
        // Hours are in 24h format
        let rawHour = time.hour!
        let (hour, meridiem) = getHourWithMeridiem(for: rawHour)
        let minute = time.minute!
        return "at \(hour):\(minute) \(meridiem)"
    }
    
    public enum Meridiem {
        case am
        case pm
        
        func localisedString() -> String {
            switch self {
            case .am:
                return "am"
            case .pm:
                return "pm"
            }
        }
    }
    
    public func getHourWithMeridiem(for hourIn24HFormat: Int) -> (Int, Meridiem) {
        let meridiem: Meridiem
        let hourIn12HFormat: Int
        if hourIn24HFormat < 12 {
            meridiem = .am
        } else {
            meridiem = .pm
        }
        if hourIn24HFormat > 12 {
            hourIn12HFormat = hourIn24HFormat - 12
        } else {
            hourIn12HFormat = hourIn24HFormat
        }
        
        return (hourIn12HFormat, meridiem)
    }
}

#if DEBUG
public func getThreeToothbrushEvents() -> [ToothbrushEventVD] {
    let event1 = ToothbrushEventVD(
        id: UUID(),
        duration: try! .init(timeInterval: 120),
        startDate: Date().advanced(by: -150)
    )
    let event2 = ToothbrushEventVD(
        id: UUID(),
        duration: try! .init(timeInterval: 100),
        startDate: Date().advanced(by: -250)
    )
    let event3 = ToothbrushEventVD(
        id: UUID(),
        duration: try! .init(timeInterval: 90),
        startDate: Date().advanced(by: -450)
    )
    return [
        event1, event2, event3
    ]
}
#endif
