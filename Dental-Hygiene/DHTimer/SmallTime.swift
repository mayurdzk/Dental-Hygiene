//
//  SmallTime.swift
//  DHTimer
//
//  Created by Mayur Dhaka on 09/11/19.
//  Copyright © 2019 Mayur Dhaka. All rights reserved.
//

import Foundation

/// Represents a small amount of time (less than one hour).
public struct SmallTime {
    public let m: Int
    public let s: Int
    
    public init() {
        m = 0
        s = 0
    }
    
    /// `throws` `SmallTimeInitError.negativeTimeNotAllowed` if `timeInterval` is not positive.
    public init(timeInterval: TimeInterval) throws {
        guard timeInterval > 0.0 else {
            throw SmallTimeInitError.negativeTimeNotAllowed
        }

        m = Int(timeInterval / secondsInAMinute)
        s = Int(timeInterval.truncatingRemainder(dividingBy: secondsInAMinute))
    }
    
    public func displayString() -> String {
        if m < 1 {
            // Time is less than one minute
            return "\(s)s"
        } else {
            // At least one minute exists
            return "\(m)m : \(s)s"
        }
    }
    
    public func timeDuration() -> TimeInterval {
        return Double(m) * secondsInAMinute + Double(s)
    }
}

private let secondsInAMinute = 60.0

public enum SmallTimeInitError: Error {
    case negativeTimeNotAllowed
}
