//
//  WaterParkBenchTimer.swift
//  WaterTracker
//
//  Created by Nik on 28.04.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import CoreFoundation

class WaterParkBenchTimer {

    let startTime: CFAbsoluteTime
    var endTime: CFAbsoluteTime?

    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }

    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()

        return duration
    }

    var duration: CFAbsoluteTime {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return 0
        }
    }
}
