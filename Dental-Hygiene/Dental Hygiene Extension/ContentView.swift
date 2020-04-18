//
//  ContentView.swift
//  Dental Hygiene Extension
//
//  Created by Mayur Dhaka on 26/10/19.
//  Copyright © 2019 Mayur Dhaka. All rights reserved.
//
import SwiftUI
import DHTTimer
import DHTAccess
import HealthKit
import Combine

struct ContentView: View {
    private let healthStore = DHTAccess(hkStore: HKHealthStore())
    @ObservedObject private var toothbrushEvents: ToothBrushEvents
    
    init() {
        toothbrushEvents = healthStore.todaysToothbrushEvents()
    }

    var body: some View {
        ScrollView {
            StartBrushingView(healthStore: healthStore)
            Spacer(minLength: 20.0)
            if toothbrushEvents.e.count > 0 {
                Text("Today")
                    .font(.headline)
                Divider()
                Spacer(minLength: 20.0)
                ForEach(toothbrushEvents.e, id: \.id) { (event) in
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
