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
    
    init(peripheral: CBPeripheral) {
        self.name = peripheral.name ?? ""
        self.id = peripheral.identifier.uuidString
        self.peripheral = peripheral
    }
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
    }
    
    required convenience init?(coder: NSCoder) {
        let id = coder.decodeObject(forKey: "id") as! String
        let name = coder.decodeObject(forKey: "name") as! String
        self.init(name: name, id: id)
    }
    
}
