//
//  HKStoreAccess.swift
//  DHTAccess
//
//  Created by Mayur Dhaka on 12/11/19.
//  Copyright © 2019 Mayur Dhaka. All rights reserved.
//

#if canImport(HealthKit)
import HealthKit
import Combine


/// Requests that the user grant you access to their HKStore for toothbrush events.
public func requestToothbrushReadAccess() -> Future<Void, DHTAccessError> {
    let allTypes = Set([HKObjectType.categoryType(forIdentifier: .toothbrushingEvent)!])
    return Future.init { signal in
        HKHealthStore().requestAuthorization(toShare: allTypes, read: nil) { (success, error) in
            guard error == nil else {
                signal(.failure(DHTAccessError.hkSaveInStoreError(error!)))
                return
            }
            guard success else {
                // I have no clue when the app would not have an error but the success
                // value is still false.
                // Crashing so we're alerted to this fact.
                fatalError("Not knowable case where this would arise")
            }
            
            signal(.success(()))
        }
    }
}
#endif
