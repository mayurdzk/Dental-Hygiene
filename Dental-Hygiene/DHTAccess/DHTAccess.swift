//
//  DHTAccess.swift
//  DHTAccess
//
//  Created by Mayur Dhaka on 26/10/19.
//  Copyright © 2019 Mayur Dhaka. All rights reserved.
//

import Combine
import HealthKit

/// Dental Health ToothbrushAccess provides a convenient way for you to
/// log toothbrush events in a HealthKit store.
///
/// All errors thrown from methods of this class are guaranteed to be wrapped in `DHTAccessError`.
public class DHTAccess {
    private let hkStore: HKHealthStore
    
    
    /// It is assumed that your app has already requested access to write toothbrush events
    /// to the user's HK store.
    ///
    /// It is also assumed, of course, that the device the user is using this app on *supports* HealthKit.
    public init(hkStore: HKHealthStore) {
        self.hkStore = hkStore
    }
    
    
    /// Logs a toothbrush event in the user's health kit store.
    /// - Parameter startTime: The time the user started brushing their teeth.
    /// - Parameter duration: The duration for which the user brushed their teeth.
    public func logToothbrushEvent(startingAt startTime: Date, duration: TimeInterval) -> Future<Void, DHTAccessError> {
        let moot = 0
        let endTime = startTime.addingTimeInterval(duration)
        
        
        let toothbrushEvent = HKObjectType.categoryType(forIdentifier: .toothbrushingEvent)!
        let toothbrushSample = HKCategorySample.init(
            type: toothbrushEvent,
            value: moot,
            start: startTime,
            end: endTime
        )
        
        return Future { [weak self] promise in
            guard let this = self else {
                promise(.failure(DHTAccessError.deinitialised))
                return
            }
            this.hkStore.save(toothbrushSample) { _, error in
                if let e = error {
                    promise(.failure(DHTAccessError.hkSaveInStoreError(e)))
                    return
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    /// Delivers to you healthkit samples from the user's healthkit data store for tooth brushing events.
    /// Samples delivered lie between the `start` and `end` dates.
    /// This method assumes `start` < `end`.
    public func readToothBrushEvents(from start: Date, to end: Date) -> Future<[HKSample], DHTAccessError> {
        let quantityType = HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.toothbrushingEvent)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])
        
        return Future { [weak self] signal in
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil) { (query, samples, error) in
                    guard error == nil else {
                        signal(.failure(.hkReadFromStoreError(error!)))
                        return
                    }
                    signal(.success(samples!))
            }
            self?.hkStore.execute(query)
        }
    }
}

#if canImport(DHTimer)

import DHTimer

extension DHTAccess {
    public func logToothbrushEventEndedNow(goingOnFor duration: SmallTime) -> Future<Void, DHTAccessError> {
        let toothbrushDuration = duration.timeDuration()
        let startDate = Date().addingTimeInterval(-toothbrushDuration)
        return logToothbrushEvent(startingAt: startDate, duration: toothbrushDuration)
    }
}

#endif
