//
//  RemoteRecordService.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

protocol RemoteRecordService: RecordService where RecordServiceError == RemoteRecordServiceError {}

enum RemoteRecordServiceError: Error {
    case serverError
}
