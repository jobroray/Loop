//
//  CGMManager.swift
//  Loop
//
//  Copyright © 2017 LoopKit Authors. All rights reserved.
//

import LoopKit
import LoopKitUI
import MockKit
import EversenseNowClient

let staticCGMManagersByIdentifier: [String: CGMManager.Type] = [
    MockCGMManager.pluginIdentifier: MockCGMManager.self,
    NowClientManager.pluginIdentifier: NowClientManager.self // <--- ADD THIS LINE
]
var availableStaticCGMManagers: [CGMManagerDescriptor] {
    // 1. Define your plugin here so we can use it in both lists
    let eversense = CGMManagerDescriptor(
        identifier: NowClientManager.pluginIdentifier,
        localizedTitle: "Eversense Now"
    )

    // 2. Check if we are in Debug/Simulator mode
    if FeatureFlags.allowSimulators {
        return [
            CGMManagerDescriptor(identifier: MockCGMManager.pluginIdentifier, localizedTitle: MockCGMManager.localizedTitle),
            eversense // <--- VITAL: Add it to the debug list!
        ]
    } else {
        // 3. Normal Mode
        return [
            eversense
        ]
    }
}

func CGMManagerFromRawValue(_ rawValue: [String: Any]) -> CGMManager? {
    guard let managerIdentifier = rawValue["managerIdentifier"] as? String,
        let rawState = rawValue["state"] as? CGMManager.RawStateValue,
        let Manager = staticCGMManagersByIdentifier[managerIdentifier]
    else {
        return nil
    }
    
    return Manager.init(rawState: rawState)
}

extension CGMManager {

    typealias RawValue = [String: Any]
    
    var rawValue: [String: Any] {
        return [
            "managerIdentifier": pluginIdentifier,
            "state": self.rawState
        ]
    }
}
