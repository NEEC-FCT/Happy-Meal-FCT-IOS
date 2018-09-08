//
//  RestaurantCollectionViewCell.swift
//  HappyMealSwift
//
//  Created by Tiago Santo on 17/02/2018.
//  Copyright © 2018 Tiago Santo. All rights reserved.
//

import UIKit

class RestaurantCollectionViewCell: BasePageCollectionCell {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var customTitle: UILabel!
    @IBOutlet weak var isItOpenLabel: UILabel!
    @IBOutlet weak var isItOpenImage: UIImageView!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var avgPriceLabel: UILabel!
    @IBOutlet weak var lunchLabel: UILabel!
    @IBOutlet weak var dinnerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customTitle.layer.shadowRadius = 2
        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTitle.layer.shadowOpacity = 0.2
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        
    }
    
}
