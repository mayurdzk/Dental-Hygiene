//
//  File.swift
//  
//
//  Created by Mayur Dhaka on 11/04/20.
//

import Foundation
import Combine
import HealthKit
import os
import Dispatch

// The problem this class has set out to solve is publishing
// toothbrush events to a caller.
// Ideally, we'd have liked something like:
// store.todaysToothbrushEvents() -> Publisher<[Event], Error>
// without the need to create a class.
// But that can't happen.
// See reference: https://developer.apple.com/videos/play/wwdc2019/721/?time=1189
// Time: 22:06

/// A class that publishes toothbrush events that ocurred today--in reverse chronological order.
public class ToothBrushEvents: ObservableObject {
    /// Changes are published on the main queue.
    @Published public var events: [ToothbrushEventVD]
    private let hkStore: HKHealthStore
    private var query: HKQuery!
    
    init(hkStore: HKHealthStore) {
        self.hkStore = hkStore
        e = []
    }
    
    deinit {
        hkStore.stop(query)
    }
    
    public func foo() {
        let quantityType = HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.toothbrushingEvent)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: nil, options: [])
        query = HKObserverQuery(
            sampleType: quantityType,
            predicate: predicate) { [weak self] (query, completion, error) in
                self?.readToothbrushSamples(signaling: { (result) in
                    switch result {
                    case .success(let events):
                        // Needed since subscribers are most-likely going to be
                        // in the UI layer.
                        DispatchQueue.main.async {
                            self?.events = events
                        }
                    case .failure(let e):
                        // TODO: Handle
                        print("Handle: \(e)")
                    }
                    // Needs to be called only when app is running in
                    // background mode but let's call it regardless here
                    // since there seems to be no harm done.
                    // Also, in case the app needs to support background execution
                    // some day, we've already done all the work.
                    completion()
                })
        }
        hkStore.execute(query)
    }
    
    /// Delivers to you healthkit samples from the user's healthkit data store for tooth brushing events.
    /// Samples delivered lie between the `start` and `end` dates.
    /// This method assumes `start` < `end`.
    private func readToothbrushSamples(
        signaling completion: @escaping (Result<[ToothbrushEventVD], Error>) -> Void
    ) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let quantityType = HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.toothbrushingEvent)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: nil, options: [])
        
        let query = HKSampleQuery(
            sampleType: quantityType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            // Thanks:
            // https://www.devfright.com/hksamplequery-tutorial-and-examples/
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { (query, samples, error) in
                guard error == nil else {
                    completion(.failure(DHTAccessError.hkReadFromStoreError(error!)))
                    return
                }
                guard let confirmedSamples = samples else {
                    os_log(.fault, "No samples found")
                    completion(.success([]))
                    return
                }
                let events = confirmedSamples.map {
                    try! ToothbrushEventVD(
                        id: $0.uuid,
                        startDate: $0.startDate,
                        endDate: $0.endDate
                    )
                }
                completion(.success(events))
        }
        hkStore.execute(query)
    }
}
