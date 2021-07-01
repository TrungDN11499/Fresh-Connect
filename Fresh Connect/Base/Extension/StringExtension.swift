//
//  StringExtension.swift
//  Project
//
//  Created by Be More on 22/03/2021.
//

import UIKit

extension String {
    /// Check if a string nil or empty
    /// - Parameters:
    ///   - aString: input string
    /// - Returns: Bool
    static func isNilOrEmpty(_ aString: String?) -> Bool {
        return !(aString != nil && "\(aString ?? "")".count != 0)
    }
    
    /// Validate email
    /// - Returns: Void
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    /// Height for  text with fixed width
    /// - Parameters:
    ///   - width: fixed width
    ///   - font: font
    /// - Returns: CGFloat
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /// Width for  text with fixed height
    /// - Parameters:
    ///   - height: fixed height
    ///   - font: font
    /// - Returns: CGFloat
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
