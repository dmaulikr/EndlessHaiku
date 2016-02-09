//
//  SettingsViewController.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 2/5/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

protocol SettingsViewControllerDelegate: class {
  func didSaveSettings()
}

class SettingsViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: Actions
  //  @IBAction func saveAction(sender: UIBarButtonItem) {
  //    print("save bar button pressed")
  //    
  //    defaults.setFloat(rate, forKey: "rate")
  //    defaults.setFloat(pitch, forKey: "pitch")
  //    defaults.setFloat(volume, forKey: "volume")
  //    
  //    defaults.synchronize()
  //    
  //    delegate?.didSaveSettings()
  //    navigationController?.popToRootViewControllerAnimated(true)
  //  }
  
  // MARK: Functions
  
  func saveAction() {
    print("save bar button pressed")
    
    defaults.setFloat(rate, forKey: "rate")
    defaults.setFloat(pitch, forKey: "pitch")
    defaults.setFloat(volume, forKey: "volume")
    
    defaults.synchronize()
    
    delegate?.didSaveSettings()
    navigationController?.popToRootViewControllerAnimated(true)
  }
  
  func handleSliderValueChanged(sender: CustomSlider) {
    switch sender.identifier {
    case 0:
      rate = sender.value
    case 1:
      pitch = sender.value
    case 2:
      volume = sender.value
    default: break
    }
    
    tableView.reloadData()
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    print("SettingsVC")
    
    rate = defaults.floatForKey("rate")
    pitch = defaults.floatForKey("pitch")
    volume = defaults.floatForKey("volume")
    
    title = "Settings"
    let barButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveAction")
    navigationItem.rightBarButtonItem = barButton
  }
  
  // MARK: Properties
  var rate: Float = 0
  var pitch: Float = 1.0
  var volume: Float = 1.0
  let defaults = NSUserDefaults.standardUserDefaults()
  
  weak var delegate: SettingsViewControllerDelegate?
  
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: CustomSliderTableViewCell!
    var currentSliderValue: Float = 0
    
    if indexPath.row < 3 {
      cell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as! CustomSliderTableViewCell
      
      switch indexPath.row {
      case 0:
        currentSliderValue = rate
        
        cell.nameLabel.text = "Rate"
        cell.valueLabel.text = String(format: "%.2f", arguments: [rate])
        cell.slider.minimumValue = AVSpeechUtteranceMinimumSpeechRate
        cell.slider.maximumValue = AVSpeechUtteranceMaximumSpeechRate
        cell.slider.identifier = 0
        
      case 1:
        currentSliderValue = pitch
        
        cell.nameLabel.text = "Pitch"
        cell.valueLabel.text = String(format: "%.2f", arguments: [pitch])
        cell.slider.minimumValue = 0.5
        cell.slider.maximumValue = 2.0
        cell.slider.identifier = 1
        
      case 2:
        currentSliderValue = volume
        
        cell.nameLabel.text = "Volume"
        cell.valueLabel.text = String(format: "%.2f", arguments: [volume])
        cell.slider.minimumValue = 0
        cell.slider.maximumValue = 1
        cell.slider.identifier = 2
        
      default: break
      }
      
      cell.slider.addTarget(self, action: "handleSliderValueChanged:", forControlEvents: .ValueChanged)
      
      if cell.slider.value != currentSliderValue {
        cell.slider.value = currentSliderValue
      }
    }
    
    return cell
    
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row < 3 {
      return 60
    }
    else{
      return 170.0
    }
  }
}



























