//
//  DeviceModel.swift
//  Fresh Connect
//
//  Created by Be More on 30/06/2021.
//

import Foundation
import CoreBluetooth

enum DeviceType {
    case scale
    case heartRateMonitor
    case other
    
    var deviceIcon: String {
        switch self {
        case .scale:
            return "scalemass"
        case .heartRateMonitor:
            return "waveform.path.ecg.rectangle"
        case .other:
            return "b.circle"
        }
    }
}

class DeviceModel {
   
    var device: CBPeripheral
    var deviceType: DeviceType
    var isConnected = false
    
    init(device: CBPeripheral, deviceType: DeviceType) {
        self.device = device
        self.deviceType = deviceType
    }
    
}
