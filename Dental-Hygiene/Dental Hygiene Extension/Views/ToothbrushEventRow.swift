//
//  ToothbrushEventRow.swift
//  Dental Hygiene Extension
//
//  Created by Mayur Dhaka on 04/04/20.
//  Copyright © 2020 Mayur Dhaka. All rights reserved.
//

import SwiftUI
import DHTAccess

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
            id: UUID(),
            duration: try! .init(timeInterval: 120),
            startDate: Date().advanced(by: -150))
        return ToothbrushEventRow(event: event)
    }
}

