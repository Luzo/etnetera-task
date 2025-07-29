//
//  OnDeviceRecordService.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

protocol OnDeviceRecordService: RecordService where RecordServiceError == OnDeviceRecordServiceError {}

enum OnDeviceRecordServiceError: Error {
    case serviceError
}
