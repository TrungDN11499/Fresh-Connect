//
//  MeasuringViewController.swift
//  Fresh Connect
//
//  Created by Be More on 30/06/2021.
//

import UIKit
import CoreBluetooth

class MeasuringViewController: BaseViewController {
    
    
    let bodyWeightCBUUID = CBUUID(string: "FFF4")
    
    /// the scale will send 11 bytes of data to to bluetooth.
    let numberOfByte = 11
    
    @IBOutlet weak var bodyWeightLabel: UILabel!
    @IBOutlet weak var connectedDeviceLabel: UILabel!
    @IBOutlet weak var measuringCollecionView: UICollectionView!
    
    var measuringModels = [MeasuringModel]() {
        didSet {
            self.measuringCollecionView.reloadData()
        }
    }
    
    var scalePeripheral: CBPeripheral!
    var centralManager: CBCentralManager!
    
    init(central: CBCentralManager, peripheral: CBPeripheral) {
        super.init(nibName: "MeasuringViewController", bundle: nil)
        self.centralManager = central
        self.scalePeripheral = peripheral
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Scale"
        self.connectedDeviceLabel.text = self.scalePeripheral.name
        self.scalePeripheral.delegate = self
        scalePeripheral.discoverServices(nil)
        
        MeasuringCollectionViewCell.registerCellByNib(self.measuringCollecionView)
    }
}

// MARK: - CBCentralManagerDelegate
extension MeasuringViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
        @unknown default:
            return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disconnected!")
        self.connectedDeviceLabel.text = "----"
        centralManager.scanForPeripherals(withServices: nil)
    }
}

// MARK: - CBPeripheralDelegate
extension MeasuringViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
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
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        
        
        switch characteristic.uuid {
        case bodyWeightCBUUID:
            let bw = bodyWeight(from: characteristic)
            print(bw)
            self.bodyWeightLabel.text = "trọng lượng cơ thể: \(bw) kg"
            self.getMoreDetail(from: bw, characteristic: characteristic)
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    private func bodyWeight(from characteristic: CBCharacteristic) -> Float {
        guard let characteristicData = characteristic.value, characteristicData.count == numberOfByte  else {
            return 0.0
        }
        
        let byteArray = [UInt8](characteristicData)
        print(byteArray)
        // body weight value format in the 3rd and 4th bytes
        let weight = (Float(byteArray[4]) * 256 + Float(byteArray[3])) / 100
        print(weight)
        return weight
    }
    
    func getMoreDetail(from weight: Float, characteristic: CBCharacteristic) {
        
        guard let characteristicData = characteristic.value, characteristicData.count == numberOfByte  else {
            return
        }
        let byteArray = [UInt8](characteristicData)
        guard byteArray[1] != 0 && byteArray[2] != 0 else  {
            return
        }
        
        let weight = weight
        let impedance = (Float(byteArray[2]) * 256 + Float(byteArray[1])) / 10
        
        print(impedance)
        
        let peopleModel = HTBodyfat_NewSDK()
        let errorType = peopleModel.getBodyfatWithweightKg(CGFloat(weight), heightCm: 170, sex: .male, age: 22, impedance: Int(impedance))
        
        
        if errorType == .none {
            let thtproteinPercentage = peopleModel.thtproteinPercentage
            print(String(format: "%.lf", thtproteinPercentage))
            
            let thtWeightKg = peopleModel.thtWeightKg
            let thtBMI = peopleModel.thtBMI
            let thtWaterPercentage = peopleModel.thtWaterPercentage
            let thtBodyfatPercentage = peopleModel.thtBodyfatPercentage
            let ThtMusclePercentage = peopleModel.thtMusclePercentage
            let thtBoneKg = peopleModel.thtBoneKg
            let thtBMR = peopleModel.thtBMR
            let thtVFAL = peopleModel.thtVFAL
            let ThtBodySubcutaneousFat = peopleModel.thtBodySubcutaneousFat
            let thtBodyAge = peopleModel.thtBodyAge
            let str = String(format: "(Hetai)\ntrọng lượng cơ thể：%.1fKG\nBMI：%.1f\nĐộ ẩm cơ thể：%.1f%%\nmập：%.1f%%\nNội dung cơ bắp：%.1f%\nNội dung xương：%.1fkg\nBMR：%ld\nChất béo nội tạng：%ld\nmỡ dưới da：%.1fKG\nTuổi thân：%ld\n", thtWeightKg, thtBMI, thtWaterPercentage, thtBodyfatPercentage, ThtMusclePercentage, thtBoneKg, thtBMR, thtVFAL, ThtBodySubcutaneousFat, thtBodyAge)
            
            print(str)
            
            self.measuringModels = [MeasuringModel(name: "BMI", value: round(Float(thtBMI) * 10) / 10.0),
                                    MeasuringModel(name: "Độ ẩm cơ thể", value: round(Float(thtWaterPercentage) * 10) / 10.0, unit: "%"),
                                    MeasuringModel(name: "mập", value: round(Float(thtBodyfatPercentage) * 10) / 10.0, unit: "%"),
                                    MeasuringModel(name: "Nội dung cơ bắp", value: round(Float(ThtMusclePercentage) * 10) / 10.0, unit: "%"),
                                    MeasuringModel(name: "Nội dung xương", value: round(Float(thtBoneKg) * 10) / 10.0, unit: "kg"),
                                    MeasuringModel(name: "BMR", value: Float(thtBMR)),
                                    MeasuringModel(name: "Chất béo nội tạng", value: Float(thtVFAL)),
                                    MeasuringModel(name: "Mỡ dưới da", value: round(Float(ThtBodySubcutaneousFat) * 10) / 10.0),
                                    MeasuringModel(name: "Tuổi thân", value: Float(thtBodyAge))]
            
//            AppInfo.myResult =  [[MeasuringModel(name: "BMI", value: round(Float(thtBMI) * 10) / 10.0),
//                                  MeasuringModel(name: "Độ ẩm cơ thể", value: round(Float(thtWaterPercentage) * 10) / 10.0, unit: "%"),
//                                  MeasuringModel(name: "mập", value: round(Float(thtBodyfatPercentage) * 10) / 10.0, unit: "%"),
//                                  MeasuringModel(name: "Nội dung cơ bắp", value: round(Float(ThtMusclePercentage) * 10) / 10.0, unit: "%"),
//                                  MeasuringModel(name: "Nội dung xương", value: round(Float(thtBoneKg) * 10) / 10.0, unit: "kg"),
//                                  MeasuringModel(name: "BMR", value: Float(thtBMR)),
//                                  MeasuringModel(name: "Chất béo nội tạng", value: Float(thtVFAL)),
//                                  MeasuringModel(name: "Mỡ dưới da", value: round(Float(ThtBodySubcutaneousFat) * 10) / 10.0),
//                                  MeasuringModel(name: "Tuổi thân", value: Float(thtBodyAge))]]
//
//            print(AppInfo.myResult)
//
        } else if errorType == .impedance {
            print("Khi trở kháng sai, trở kháng sai, Không tính toán chia BMI/idealWeightKg Các thông số khác (ghi 0)")
        } else if errorType == .age {
            print("Tham số tuổi bị sai, cần phải ở trong 10 ~ 99 tuổi (không tính các thông số ngoài BMI / idealWeightKg)")
        } else if errorType == .weight {
            print("Thông số trọng lượng bị sai, cần phải từ 10 ~ 200kg (tất cả các thông số sẽ không được tính nếu sai)")
        } else if errorType == .height {
            print("Thông số chiều cao bị sai, cần phải là 90 ~ 220cm (không tính tất cả các thông số)")
        }
        
        
    }
    
}

// MARK: - UICollectionViewDelegate
extension MeasuringViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension MeasuringViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.measuringModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = MeasuringCollectionViewCell.loadCell(collectionView, indexPath: indexPath) as? MeasuringCollectionViewCell else {
            return MeasuringCollectionViewCell()
        }
        cell.model = self.measuringModels[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension MeasuringViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellPadding: CGFloat = 10
        let cellWidth: CGFloat = (self.view.frame.width - cellPadding * 4) / 3
        let cellHeight = cellWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

