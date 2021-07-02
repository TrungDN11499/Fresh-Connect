//
//  MeasuringCollectionViewCell.swift
//  Fresh Connect
//
//  Created by Be More on 02/07/2021.
//

import UIKit

class MeasuringCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var model: MeasuringModel? {
        didSet {
            self.setUpData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

// MARK: - Helpers
extension MeasuringCollectionViewCell {
    func setUpData() {
        guard let model = self.model else { return }
        print(model)
        self.nameLabel.text = model.name
        self.valueLabel.text = "\(model.value)\(model.unit)"
    }
}
