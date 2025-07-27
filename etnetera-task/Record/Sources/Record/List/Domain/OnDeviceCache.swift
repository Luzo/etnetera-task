//
//  OnDeviceCache.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

protocol OnDeviceCache: Sendable {
    func getRecords() async -> [ActivityRecord]
    func addRecord(_ newRecord: ActivityRecord) async
}
