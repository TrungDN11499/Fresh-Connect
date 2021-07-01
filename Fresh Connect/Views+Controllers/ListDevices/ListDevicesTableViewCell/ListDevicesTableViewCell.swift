//
//  ListDevicesTableViewCell.swift
//  Fresh Connect
//
//  Created by Be More on 30/06/2021.
//

import UIKit
import CoreBluetooth

class ListDevicesTableViewCell: BaseTableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    var model: DeviceModel? {
        didSet {
            self.setUpData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconImageView.image = self.iconImageView.image?.withRenderingMode(.alwaysTemplate)
        self.iconImageView.tintColor = .black
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

// MARK: - Helpers
extension ListDevicesTableViewCell {
    private func setUpData() {
        guard let model = self.model else { return }
        self.deviceNameLabel.text = String.isNilOrEmpty(model.device.name) ? model.device.identifier.uuidString : model.device.name
        self.iconImageView.image = UIImage(systemName: model.deviceType.deviceIcon)
    }
}
