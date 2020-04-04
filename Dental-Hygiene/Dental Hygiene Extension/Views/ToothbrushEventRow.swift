//
//  ToothbrushEventRow.swift
//  Dental Hygiene Extension
//
//  Created by Mayur Dhaka on 04/04/20.
//  Copyright © 2020 Mayur Dhaka. All rights reserved.
//

import SwiftUI
import DHTTimer

struct ToothbrushEventRow: View {
    let event: ToothbrushEventVD

    var body: some View {
        VStack {
            HStack {
                Text(event.duration.displayString())
                    .font(Font.largeTitle)
                Spacer()
                
            }
            HStack {
                Text("\(event.localisedStartTime())")
                Spacer()
            }
        }
    }
}

struct ToothbrushEventRow_Previews: PreviewProvider {
    static var previews: some View {
        let event = ToothbrushEventVD(
            duration: try! .init(timeInterval: 120),
            startDate: Date().advanced(by: -150))
        return ToothbrushEventRow(event: event)
    }
}

struct ToothbrushEventVD {
    let duration: SmallTime
    let startDate: Date
    
    func localisedStartTime() -> String {
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
    
    enum Meridiem {
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
    
    func getHourWithMeridiem(for hourIn24HFormat: Int) -> (Int, Meridiem) {
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
