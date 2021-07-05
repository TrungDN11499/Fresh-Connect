//
//  HeartRateMeasuringViewController.swift
//  Fresh Connect
//
//  Created by Be More on 05/07/2021.
//

import UIKit
import CoreBluetooth
import Charts

class HeartRateMeasuringViewController: UIViewController {
    
    private lazy var lineChart: LineChartView = {
        let chartView = LineChartView()
        return chartView
    }()
    
    var heartRateData = [ChartDataEntry]()
    
    var dataCounter = 0
    
    var monitorPeripheral: CBPeripheral!
    var centralManager: CBCentralManager!
    
    let heartRateCBUUID = CBUUID(string: "2344C102-7994-1CCA-B98B-00FFD0B3CA8A")
    
    // MARK: - Initializers
    init(central: CBCentralManager, peripheral: CBPeripheral) {
        super.init(nibName: "HeartRateMeasuringViewController", bundle: nil)
        self.centralManager = central
        self.monitorPeripheral = peripheral
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Heart Rate Monitor"
        self.monitorPeripheral.delegate = self
        monitorPeripheral.discoverServices(nil)
        
        self.view.addSubview(self.lineChart)
        self.lineChart.centerX(inView: self.view)
        self.lineChart.centerY(inView: self.view)
        self.lineChart.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        self.lineChart.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
    }
    
    
}

extension HeartRateMeasuringViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print(characteristic.uuid)
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        
        
        switch characteristic.uuid {
        case heartRateCBUUID:
            print(self.heartRate(from: characteristic))
            print(self.dataCounter)
            let heartRate = Float(self.heartRate(from: characteristic)) / 1000.0
            let data = ChartDataEntry(x: Double(self.dataCounter), y: Double(heartRate))
            self.heartRateData.append(data)
            self.dataCounter += 1
            let set1 = LineChartDataSet(entries: heartRateData, label: "")
            
            let lineChartData = LineChartData(dataSet: set1)
            self.lineChart.data = lineChartData
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
        
        
    }
    
    
    private func heartRate(from characteristic: CBCharacteristic) -> Int {
      guard let characteristicData = characteristic.value else { return -1 }
      let byteArray = [UInt8](characteristicData)

      let firstBitValue = byteArray[0] & 0x01
      if firstBitValue == 0 {
        // Heart Rate Value Format is in the 2nd byte
        return Int(byteArray[1])
      } else {
        // Heart Rate Value Format is in the 2nd and 3rd bytes
        return (Int(byteArray[1]) << 8) + Int(byteArray[2])
      }
    }
    
}
