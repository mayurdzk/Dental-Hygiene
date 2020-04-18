//
//  ToothbrushEventsList.swift
//  Dental Hygiene Extension
//
//  Created by Mayur Dhaka on 04/04/20.
//  Copyright © 2020 Mayur Dhaka. All rights reserved.
//

import SwiftUI
import DHTAccess

struct ToothbrushEventsList: View {
    let toothbrushEvents: [ToothbrushEventVD]

    var body: some View {
        List(toothbrushEvents, id: \.id) { (event) in
            ToothbrushEventRow(event: event)
        }
    }
}

struct ToothbrushEventsList_Previews: PreviewProvider {
    static var previews: some View {
        ToothbrushEventsList(toothbrushEvents: getThreeToothbrushEvents())
    }
}
