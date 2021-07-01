//
//  MeasuringModel.swift
//  Fresh Connect
//
//  Created by Be More on 30/06/2021.
//

import Foundation

class MeasuringModel {
    var name: String
    var value: Float
    var unit: String
    
    init(name: String, value: Float, unit: String = "") {
        self.name = name
        self.value = value
        self.unit = unit
    }
}
