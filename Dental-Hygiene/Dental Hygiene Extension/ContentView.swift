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


struct ContentView: View {
    @State private var isUserBrushing: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.isUserBrushing.toggle()
            }, label: { Text(
                // TODO: Use localisation
                isUserBrushing ? "Stop" : "Start"
                )
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
