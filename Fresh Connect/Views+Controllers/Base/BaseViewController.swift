//
//  BaseViewController.swift
//  Fresh Connect
//
//  Created by Be More on 02/07/2021.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Lifecycles
    var haveStatusBar: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                return false
            case 1334:
                print("iPhone 6/6S/7/8")
                return false
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                return false
            case 2436:
                print("iPhone X/XS/11 Pro")
                return true
            case 2688:
                print("iPhone XS Max/11 Pro Max")
                return true
            case 1792:
                print("iPhone XR/ 11 ")
                return true
            case 2532:
                return true
            case 2778:
                return true
            default:
                return false
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.bindViewModel()
        self.configureUI()
    }
    
    func showLoading() {
        Helper.shared.showLoading(inView: self.view)
    }
    
    func hideLoading() {
        Helper.shared.hideLoading(inView: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChageFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Selectors
    @objc private func handleResignFirstResponder() {
        self.view.endEditing(true)
    }
    
    // MARK: - Helpers
    /// for configuring  view options
    func configureView() {
        self.view.backgroundColor = .white
    }
    
    
    /// for programmatically configuring UI
    func configureUI() {
        
    }
    
    /// for binding view model
    func bindViewModel() {
        
    }
    
    func getMessageNoData(message : String) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor(hexString: "#C4C4C4") ?? .lightGray
        ]
        let attributedMessage = NSAttributedString(string: message, attributes: attributes)
        return attributedMessage;
    }
    
    
    @objc fileprivate func keyboardWillAppear(_ notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardRectangle = keyboardFrame?.cgRectValue
        let keyboardHeight = keyboardRectangle?.height
        let durationNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let duration = durationNumber?.doubleValue
        let keyboardCurveNumber = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let keyboardCurve = keyboardCurveNumber?.uintValue

        self.keyboardWillShow(keyboardHeight: keyboardHeight, duration: duration, keyboardCurve: keyboardCurve)
    }
    
    @objc fileprivate func keyboardDidShow(_ notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardRectangle = keyboardFrame?.cgRectValue
        let keyboardHeight = keyboardRectangle?.height
        let durationNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let duration = durationNumber?.doubleValue
        let keyboardCurveNumber = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let keyboardCurve = keyboardCurveNumber?.uintValue

        self.keyboardDidShow(keyboardHeight: keyboardHeight, duration: duration, keyboardCurve: keyboardCurve)
    }
    
    @objc fileprivate func keyboardWillChageFrame(_ notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardRectangle = keyboardFrame?.cgRectValue
        let keyboardHeight = keyboardRectangle?.height
        let durationNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let duration = durationNumber?.doubleValue
        let keyboardCurveNumber = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let keyboardCurve = keyboardCurveNumber?.uintValue

        self.keyboardDidShow(keyboardHeight: keyboardHeight, duration: duration, keyboardCurve: keyboardCurve)
    }

    @objc fileprivate func keyboardWillDisappear(_ notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardRectangle = keyboardFrame?.cgRectValue
        let keyboardHeight = keyboardRectangle?.height
        let durationNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let duration = durationNumber?.doubleValue
        let keyboardCurveNumber = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let keyboardCurve = keyboardCurveNumber?.uintValue

        self.keyboardHide(keyboardHeight: keyboardHeight, duration: duration, keyboardCurve: keyboardCurve)
    }

    func keyboardWillShow(keyboardHeight: CGFloat?, duration: Double?, keyboardCurve: UInt?) {

    }
    
    func keyboardDidShow(keyboardHeight: CGFloat?, duration: Double?, keyboardCurve: UInt?) {
        
    }

    func keyboardWillChageFrame(keyboardHeight: CGFloat?, duration: Double?, keyboardCurve: UInt?) {
        
    }
    
    func keyboardHide(keyboardHeight: CGFloat?, duration: Double?, keyboardCurve: UInt?) {

    }
    
}

