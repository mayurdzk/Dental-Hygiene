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
    private let healthStore = HKDHTStore(hkStore: HKHealthStore())

    var body: some View {
        ScrollView {
            StartBrushingView(healthStore: healthStore)
            Spacer(minLength: 20.0)
            TodaysToothbrushEventsView(
                events: healthStore.todaysToothbrushEvents()
            )
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
