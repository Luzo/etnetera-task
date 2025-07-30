//
//  ReachabilityService.swift
//  Record
//
//  Created by Lubos Lehota on 30/07/2025.
//

protocol ReachabilityService: Sendable {
    func isConnected() async -> Bool
}
