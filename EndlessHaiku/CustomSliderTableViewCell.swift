//
//  CustomSliderTableViewCell.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 2/5/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit
import ASValueTrackingSlider

/// UITableViewCell with UILabel and UISlider
class CustomSliderTableViewCell: UITableViewCell {
  
  // MARK: Outlets
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var slider: CustomSlider!
  
  // MARK: Lifecycle
  override func awakeFromNib() {
    slider.delegate = self
  }
}

extension CustomSliderTableViewCell: ASValueTrackingSliderDelegate {
  func sliderWillDisplayPopUpView(slider: ASValueTrackingSlider!) {
    self.superview!.bringSubviewToFront(slider)
  }
}