//
//  DHTAccessError.swift
//  Dental-Hygiene
//
//  Created by Mayur Dhaka on 26/10/19.
//  Copyright © 2019 Mayur Dhaka. All rights reserved.
//


/// Errors thrown by this library.
public enum DHTAccessError: Error {
    case deinitialised
    case hkSaveInStoreError(Error)
    case hkReadFromStoreError(Error)
    case hkStoreAccessError(Error)
}
