//
//  RecordController.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

protocol RecordService: Sendable {
    associatedtype RecordServiceError: Error

    @discardableResult
    func saveRecord(_ record: ActivityRecord) async -> Result<Void, RecordServiceError>
    func loadRecords() async -> Result<[ActivityRecord], RecordServiceError>
}
