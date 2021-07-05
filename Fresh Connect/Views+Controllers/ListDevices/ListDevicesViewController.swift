//
//  ListDevicesViewController.swift
//  Fresh Connect
//
//  Created by Be More on 30/06/2021.
//

import UIKit
import CoreBluetooth
import DZNEmptyDataSet

class ListDevicesViewController: BaseViewController {
    
    var centralManager: CBCentralManager!
    @IBOutlet weak var devicesListTableView: UITableView!
    @IBOutlet weak var myDeviceCollectionView: UICollectionView!
    
    var listDevices = [DeviceModel]()
    
    var myDevices = [MyDeviceModel]() {
        didSet {
            self.myDeviceCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Fresh Connect"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        ListDevicesTableViewCell.registerCellByNib(self.devicesListTableView)
        MyDevicesCollectionViewCell.registerCellByNib(self.myDeviceCollectionView)
        
        if let myDevices = AppInfo.myDevices {
            if myDevices.count != 0 {
                self.myDevices = myDevices
            }
        }
        
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
        self.hideLoading()
        guard let name = peripheral.name else {
            return
        }
        
        if name.contains("1SK-SmartScale")  {
            let measuringController = MeasuringViewController(central: self.centralManager, peripheral: peripheral)
            self.navigationController?.pushViewController(measuringController, animated: true)
        } else if name.contains("ECGRec") {
            let measuringController = HeartRateMeasuringViewController(central: self.centralManager, peripheral: peripheral)
            self.navigationController?.pushViewController(measuringController, animated: true)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        if  let name = peripheral.name {
            if name.contains("1SK-SmartScale") || name.contains("ECGRec") {
                var canAppend = true
            
                for i in 0 ..< self.myDevices.count {
                    if peripheral.identifier.uuidString == self.myDevices[i].id {
                        self.myDevices[i].canConnect = true
                        self.myDevices[i].peripheral = peripheral
                        self.myDeviceCollectionView.reloadItems(at: [IndexPath(item: i, section: 0)])
                        canAppend = false
                        break
                    }
                }
                
                // loop through the list to check for duplication.
                if canAppend {
                    for device in self.listDevices {
                        if device.device.identifier == peripheral.identifier  {
                            canAppend = false
                            break
                        }
                    }
                }
                
                // add new item
                if canAppend {
                    if let peripheralName = peripheral.name {
                        if peripheralName.contains("Scale") {
                            self.listDevices.append(DeviceModel(device: peripheral, deviceType: .scale))
                        } else if peripheralName.contains("ECGRec") {
                            self.listDevices.append(DeviceModel(device: peripheral, deviceType: .heartRateMonitor))
                        } else {
                            self.listDevices.append(DeviceModel(device: peripheral, deviceType: .other))
                        }
                        let newIndexPath = IndexPath(row: (listDevices.count) - 1, section: 0)
                        self.devicesListTableView.insertRows(at: [newIndexPath], with: .fade)
                    }
                }
            
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        for i in 0 ..< self.myDevices.count {
            if peripheral.identifier.uuidString == self.myDevices[i].id {
                self.myDevices[i].canConnect = false
                self.myDevices[i].peripheral = nil
                self.myDeviceCollectionView.reloadItems(at: [IndexPath(item: i, section: 0)])
                break
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ListDevicesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let peripheral = self.myDevices[indexPath.item].peripheral else {
            self.presentMessage("Your device is disconnected")
            return
        }
        self.showLoading()
        self.centralManager.connect(peripheral)
    }
}

// MARK: - UICollectionViewDataSource
extension ListDevicesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myDevices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = MyDevicesCollectionViewCell.loadCell(collectionView, indexPath: indexPath) as? MyDevicesCollectionViewCell else {
            return MyDevicesCollectionViewCell()
        }
        cell.model = self.myDevices[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension ListDevicesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}


// MARK: - UITableViewDelegate
extension ListDevicesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let deviceName = self.listDevices[indexPath.row].device.name, deviceName.contains("1SK-SmartScale") || deviceName.contains("ECGRec") else { return }
        
        let myDevice = MyDeviceModel(peripheral: self.listDevices[indexPath.row].device)
        myDevice.canConnect = true
        self.myDevices.append(myDevice)
        AppInfo.myDevices = self.myDevices
    
        self.listDevices.remove(at: indexPath.row)
        self.devicesListTableView.deleteRows(at: [indexPath], with: .fade)
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

// MARK: - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
extension ListDevicesViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return self.getMessageNoData(message: "No device yet");
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
