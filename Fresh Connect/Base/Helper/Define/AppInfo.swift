//
//  AppInfo.swift
//  Fresh Connect
//
//  Created by Be More on 01/07/2021.
//

import Foundation

let K_MYDEVICE = "K_MYDEVICE"

class AppInfo: NSObject {
    
    /// Save device
    static var myDevices: [MyDeviceModel]? {
        get {
            guard let decoded = UserDefaults.standard.data(forKey: K_MYDEVICE) else {
                return nil
            }
            guard let decodedData = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [MyDeviceModel] else {
                return nil
            }
            return decodedData
        } set {
            if let newValue = newValue {
                do {
                    let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
                    UserDefaults.standard.set(encodedData, forKey: K_MYDEVICE)
                    UserDefaults.standard.synchronize()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    static func removeAllData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
}
