//
//  ContentView.swift
//  Dental Hygiene Extension
//
//  Created by Mayur Dhaka on 26/10/19.
//  Copyright © 2019 Mayur Dhaka. All rights reserved.
//

import Combine
import DHTAccess
import HealthKit
import SwiftUI
import DHTTimer

struct ContentView: View {
    @State private var brushingTime = SmallTime()
    @State private var isUserBrushing: Bool = false
    private let healthStore = DHTAccess(hkStore: HKHealthStore())
    private let timer: DHTTimer = DHTTimer()
    
    var body: some View {
        VStack {
            Text(brushingTime.displayString())
            Button(action: {
                self.isUserBrushing.toggle()
                if self.isUserBrushing {
                    self.startBrushingTeeth()
                } else {
                    self.stopBrushingTeeth()
                }
            }, label: { Text(
                // TODO: Use localisation
                isUserBrushing ? "Stop" : "Start"
                )
            })
            #if DEBUG
            Button(action: {
                let result = self.healthStore.logToothbrushEventEndedNow(goingOnFor: try! SmallTime(timeInterval: 120.0))
                .map { (_) -> Void in
                    print("Done")
                }.mapError { (e) -> Error in
                    print(e)
                    return e
                }
                print(result)
            }, label: { Text("2mins") })
            #endif
        }
    }
    
    private func startBrushingTeeth() {
        timer.start {(t) in
            self.brushingTime = t
        }
    }
    
    private func stopBrushingTeeth() {
        logToothbrushEvent()
        timer.stop()
        brushingTime = SmallTime()
    }
    
    private func logToothbrushEvent() {
        _ = healthStore.logToothbrushEventEndedNow(goingOnFor: brushingTime)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
