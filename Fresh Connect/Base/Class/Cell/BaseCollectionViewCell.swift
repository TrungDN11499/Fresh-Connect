//
//  BMCollectionViewCell.swift
//  Project
//
//  Created by Be More on 11/1/20.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Lifecycles.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    // MARK: - Helpers.
    static func registerCellByNib(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: self.nibName(), bundle: nil), forCellWithReuseIdentifier: self.nibName())
    }
    
    static func registerCellByClass(_ collectionView: UICollectionView) {
        collectionView.register(self.self, forCellWithReuseIdentifier: self.nibName())
    }
    
    static func loadCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> BaseCollectionViewCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.nibName(), for: indexPath) as? BaseCollectionViewCell else {
            return BaseCollectionViewCell()
        }
        return cell
    }
    
}

