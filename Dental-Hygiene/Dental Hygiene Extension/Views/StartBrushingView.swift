//
//  StartBrushingView.swift
//  Dental Hygiene Extension
//
//  Created by Mayur Dhaka on 04/04/20.
//  Copyright © 2020 Mayur Dhaka. All rights reserved.
//

import SwiftUI
import Combine
import DHTAccess
import HealthKit
import DHTTimer

struct StartBrushingView: View {
    @State private var brushingTime = SmallTime()
    @State private var isUserBrushing: Bool = false
    let healthStore: DHTAccess
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
                let _ = self.healthStore
                    .logToothbrushEventEndedNow(
                        goingOnFor: try! SmallTime(timeInterval: 120.0)
                )
            }, label: { Text("2mins") })
            #endif
        }
    }
    
    private func startBrushingTeeth() {
        _ = requestToothbrushReadAccess()
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

struct StartBrushingView_Previews: PreviewProvider {
    static var previews: some View {
        StartBrushingView(healthStore: DHTAccess(hkStore: HKHealthStore()))
    }
}
