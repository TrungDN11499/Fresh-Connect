//
//  ExtensionUIViewController.swift
//  Fresh Connect
//
//  Created by Be More on 01/07/2021.
//

import Foundation

extension UIViewController {
    
    /// present alert with one button
    /// - Parameters:
    ///   - error: errort to present
    /// - Returns: Voic
    func presentError(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    /// present message with one button
    /// - Parameters:
    ///   - message: message to present
    /// - Returns: Void
    func presentMessage(_ message: String) {
        let alertController = UIAlertController(title: "Message",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    /// present message with two buttons
    /// - Parameters:
    ///   - message: message to present
    /// - Returns: Void
    func presentMessage(_ message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Message",
                                                message: message,
                                                preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default, handler: handler)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Change root view controller
    /// - Parameters:
    ///   - rootViewController: change to view controller
    ///   - options: animation option, default is curveLinear
    ///   - duration: animation duration, default is 0
    /// - Returns: Void
    func changeRootViewControllerTo(rootViewController: UIViewController, withOption options: UIView.AnimationOptions = .curveLinear, duration: TimeInterval = 0) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }
    
        sceneDelegate.window?.rootViewController = rootViewController
        
        UIView.transition(with: sceneDelegate.window!,
                          duration: duration,
                          options: options,
                          animations: {},
                          completion:{ completed in })
    }
}
