//
//  TodaysToothbrushEvents.swift
//  Dental Hygiene Extension
//
//  Created by Mayur Dhaka on 18/04/20.
//  Copyright © 2020 Mayur Dhaka. All rights reserved.
//

import SwiftUI
import DHTAccess


// The only reason this view is prefixed with `Today` is because of the labels
// it uses. Nothing else is "today" about it.
struct TodaysToothbrushEventsView: View {
    @ObservedObject private var toothbrushEvents: ToothBrushEvents
    
    init(events: ToothBrushEvents) {
        toothbrushEvents = events
    }

    var body: some View {
        // Need to wrap inside a `VStack` since
        // the compiler can't figure out the underlying expression evaluates to
        // a `View`, otherwise.
        // Bum!
        VStack {
            if toothbrushEvents.events.count > 0 {
                Text("Today")
                    .font(.headline)
                Divider()
                Spacer(minLength: 20.0)
                ForEach(toothbrushEvents.events, id: \.id) { (event) in
                    VStack {
                        ToothbrushEventRow(event: event)
                        Divider()
                    }
                }
            } else {
                Text("No events today.")
                    .font(.footnote)
            }
        }
    }
}
