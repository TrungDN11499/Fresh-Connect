//
//  MyDeviceModel.swift
//  Fresh Connect
//
//  Created by Be More on 01/07/2021.
//

import Foundation
import CoreBluetooth

class MyDeviceModel: NSObject, NSCoding {
    
    var name: String
    var id: String
    var peripheral: CBPeripheral?
    var canConnect = false
    var deviceType = 0
    
    init(peripheral: CBPeripheral) {
        self.name = peripheral.name ?? ""
        self.id = peripheral.identifier.uuidString
        self.peripheral = peripheral
        
        if let peripheralName = peripheral.name {
            if peripheralName.contains("Scale") {
                deviceType = 0
            } else if peripheralName.contains("ECGRec") {
                deviceType = 1
            } else {
                deviceType = 2
            }
        }
    }
    
    init(name: String, id: String, deviceType: Int) {
        self.name = name
        self.id = id
        self.deviceType = deviceType
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(deviceType, forKey: "deviceType")
    }
    
    required convenience init?(coder: NSCoder) {
        let id = coder.decodeObject(forKey: "id") as! String
        let name = coder.decodeObject(forKey: "name") as! String
        let deviceType = coder.decodeInteger(forKey: "deviceType")
        self.init(name: name, id: id, deviceType: deviceType)
    }
    
}
