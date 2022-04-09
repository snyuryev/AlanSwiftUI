//
//  AlanSDKButtonState+CustomStringConvertible.swift
//  AlanSwiftUI
//
//  Created by Sergey Yuryev on 09.04.2022.
//

import AlanSDK

extension AlanSDKButtonState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .connecting:
            return "connecting"
        case .offline:
            return "offline"
        case .online:
            return "online"
        case .idle:
            return "idle"
        case .listen:
            return "listen"
        case .process:
            return "process"
        case .reply:
            return "reply"
        case .noPermission:
            return "noPermission"
        @unknown default:
            return "unknown"
        }
    }
}
