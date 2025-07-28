//
//  RemoteRecordService.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

protocol RemoteRecordService: RecordService where Record == ActivityRecordDTO, RecordServiceError == RemoteRecordServiceError {
}

enum RemoteRecordServiceError: Error {
    case serverError
}
