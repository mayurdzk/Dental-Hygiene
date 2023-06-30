//
//  FakeHKStore.swift
//  Dental Hygiene Extension
//
//  Created by Mayur Dhaka on 30/06/23.
//  Copyright © 2023 Mayur Dhaka. All rights reserved.
//

import Foundation
import DHTAccess
import Combine

class FakeDHTAccess: DHTStore {
    func logToothbrushEvent(startingAt startTime: Date, duration: TimeInterval) -> Future<Void, DHTAccess.DHTAccessError> {
        fatalError("This should never be called. This store is only intended for SwiftUI content previews")
    }
    
    func todaysToothbrushEvents() -> DHTAccess.ToothBrushEvents {
        fatalError("This should never be called. This store is only intended for SwiftUI content previews")
    }
    
    
}
