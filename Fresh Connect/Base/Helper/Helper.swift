//
//  Helper.swift
//  Fresh Connect
//
//  Created by Be More on 02/07/2021.
//

import Foundation
import MBProgressHUD

class Helper {
    
    static let shared = Helper()
    
    open func showLoading(inView view: UIView) {
        MBProgressHUD.showAdded(to: view, animated: true).show(animated: true)
    }
    
    open func hideLoading(inView view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    var currentCurrencyGroupingSeparator: String {
        let local = Locale.current
        return local.groupingSeparator ?? "."
    }
    
    var currentCurrencyDecimalSeparator: String {
        let local = Locale.current
        return local.decimalSeparator ?? ","
    }
    
}

