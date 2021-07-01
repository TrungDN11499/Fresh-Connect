//
//  ListDevicesViewController.swift
//  Fresh Connect
//
//  Created by Be More on 30/06/2021.
//

import UIKit
import CoreBluetooth

class ListDevicesViewController: UIViewController {
    
    var centralManager: CBCentralManager!
    @IBOutlet weak var devicesListTableView: UITableView!
    
    var listDevices = [DeviceModel]() {
        didSet {
            let newIndexPath = IndexPath(row: (listDevices.count) - 1, section: 0)
            self.devicesListTableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Fresh Connect"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        ListDevicesTableViewCell.registerCellByNib(self.devicesListTableView)
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.centralManager.stopScan()
    }
}

// MARK: - CBCentralManagerDelegate
extension ListDevicesViewController: CBCentralManagerDelegate {
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
            centralManager.scanForPeripherals(withServices: nil)
        @unknown default:
            return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        self.centralManager.stopScan()
        let measuringController = MeasuringViewController(central: self.centralManager, peripheral: peripheral)
        self.navigationController?.pushViewController(measuringController, animated: true)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        var canAppend = true
        
        // add the first item.
        if listDevices.count == 0  {
            if let peripheralName = peripheral.name?.lowercased() {
                if peripheralName.contains("scale") {
                    self.listDevices.append(DeviceModel(device: peripheral, deviceType: .scale))
                } else {
                    self.listDevices.append(DeviceModel(device: peripheral, deviceType: .other))
                }
            }
        }
        
        // loop through the list to check for duplication.
        for device in self.listDevices {
            if device.device.identifier == peripheral.identifier  {
                canAppend = false
                break
            }
        }
        
        // add new item
        if canAppend {
            if let peripheralName = peripheral.name?.lowercased() {
                if peripheralName.contains("scale") {
                    self.listDevices.append(DeviceModel(device: peripheral, deviceType: .scale))
                } else {
                    self.listDevices.append(DeviceModel(device: peripheral, deviceType: .other))
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ListDevicesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let deviceName = self.listDevices[indexPath.row].device.name, deviceName == "1SK-SmartScale68" else { return }
        self.centralManager.connect(self.listDevices[indexPath.row].device)
    }
}

// MARK: - UITableViewDataSource
extension ListDevicesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ListDevicesTableViewCell.loadCell(tableView, indexPath: indexPath) as? ListDevicesTableViewCell else { return ListDevicesTableViewCell() }
        cell.model = self.listDevices[indexPath.row]
        return cell
    }
}
