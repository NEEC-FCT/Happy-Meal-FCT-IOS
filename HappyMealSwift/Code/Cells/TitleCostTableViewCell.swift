//
//  TitleCostTableViewCell.swift
//  HappyMealSwift
//
//  Created by Tiago Santo on 20/02/2018.
//  Copyright © 2018 Tiago Santo. All rights reserved.
//

import Foundation
import UIKit

class TitleCostTableViewCell: UITableViewCell {
    
    static let CellIdentifier = String(describing: TitleCostTableViewCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}
