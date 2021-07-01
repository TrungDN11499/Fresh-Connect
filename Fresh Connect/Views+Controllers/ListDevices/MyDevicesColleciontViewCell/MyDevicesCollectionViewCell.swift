//
//  MyDevicesCollectionViewCell.swift
//  Fresh Connect
//
//  Created by Be More on 01/07/2021.
//

import UIKit

class MyDevicesCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var connectImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var model: MyDeviceModel? {
        didSet {
            self.setUpData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }

}

// MARK: - Helpers
extension MyDevicesCollectionViewCell {
    func setUpData() {
        guard let model = self.model else { return }
        self.nameLabel.text = model.name
        self.connectImageView.image = self.connectImageView.image?.withRenderingMode(.alwaysTemplate)
        self.connectImageView.tintColor = model.canConnect ? .green : .lightGray
        
    }
}
