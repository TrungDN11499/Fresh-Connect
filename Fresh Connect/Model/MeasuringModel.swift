//
//  MeasuringModel.swift
//  Fresh Connect
//
//  Created by Be More on 30/06/2021.
//

import Foundation

class MeasuringModel: NSObject, NSCoding {
    
    var name: String
    var value: Float
    var unit: String
    
    init(name: String, value: Float, unit: String = "") {
        self.name = name
        self.value = value
        self.unit = unit
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(value, forKey: "value")
        coder.encode(name, forKey: "name")
        coder.encode(unit, forKey: "unit")
    }
    
    required convenience init?(coder: NSCoder) {
        let value = coder.decodeFloat(forKey: "value")
        let name = coder.decodeObject(forKey: "name") as! String
        let unit = coder.decodeObject(forKey: "unit") as! String
        self.init(name: name, value: value, unit: unit)
    }
    
}
