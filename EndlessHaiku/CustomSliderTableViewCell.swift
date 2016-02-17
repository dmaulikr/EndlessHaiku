//
//  CustomSliderTableViewCell.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 2/5/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit

/// UITableViewCell with UILabel and UISlider
class CustomSliderTableViewCell: UITableViewCell {
  
  // MARK: Outlets
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var slider: CustomSlider!
}
