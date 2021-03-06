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
import MoPub
import ASValueTrackingSlider
import ChameleonFramework


protocol SettingsViewControllerDelegate: class {
  func didSaveSettings()
}

class SettingsViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: Option
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    
    rate = defaults.floatForKey(UserDefaultsKey.rate)
    pitch = defaults.floatForKey(UserDefaultsKey.pitch)
    volume = defaults.floatForKey(UserDefaultsKey.volume)
    selectedVoiceLanguageIndex = defaults.integerForKey(UserDefaultsKey.languageCodeIndex)
    
    title = "Settings"
    let barButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveAction))
    navigationItem.rightBarButtonItem = barButton
    
    prepareVoiceList()
    
    tableView.accessibilityIdentifier = "SettingsTable"
  }
  
  // MARK: Properties
  var rate: Float = 0
  var pitch: Float = 1.0
  var volume: Float = 1.0
  let defaults = NSUserDefaults.standardUserDefaults()
  
  var voiceLanguages = [[String:String]]()
  var selectedVoiceLanguageIndex: Int = 8
  
  weak var delegate: SettingsViewControllerDelegate?
  
}

// MARK: - Helpers
extension SettingsViewController {
  
  /**
   Save the updated AVSpeechSynthesis settings to NSUserDefaults and pop back to root VC.
   */
  func saveAction() {
    print("save bar button pressed")
    
    defaults.setFloat(rate, forKey: UserDefaultsKey.rate)
    defaults.setFloat(pitch, forKey: UserDefaultsKey.pitch)
    defaults.setFloat(volume, forKey: UserDefaultsKey.volume)
    
    defaults.setObject(voiceLanguages[selectedVoiceLanguageIndex][UserDefaultsKey.languageCode], forKey: UserDefaultsKey.languageCode)
    defaults.setInteger(selectedVoiceLanguageIndex, forKey: UserDefaultsKey.languageCodeIndex)
    
    defaults.synchronize()
    
    delegate?.didSaveSettings()
    navigationController?.popToRootViewControllerAnimated(true)
  }
  
  /**
   Update the variables to the sliders value.
   
   - parameter sender: slider
   */
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
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
      
      let pickerCell = tableView.dequeueReusableCellWithIdentifier("PickerCell", forIndexPath: indexPath) as! CustomPickerTableViewCell
      
      pickerCell.accessibilityIdentifier = "PickerCell"
      
      pickerCell.pickerView.delegate = self
      pickerCell.pickerView.dataSource = self
      
      pickerCell.pickerView.showsSelectionIndicator = true
      pickerCell.pickerView.selectRow(selectedVoiceLanguageIndex, inComponent: 0, animated: true)
      
      pickerCell.pickerView.accessibilityIdentifier = "VoiceLanguage"
      
      return pickerCell
      
    } else {
      
      let sliderCell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as! CustomSliderTableViewCell
      
      var currentSliderValue: Float = 0
      
      switch indexPath.row {
      case 1:
        currentSliderValue = rate
        
        sliderCell.accessibilityIdentifier = "RateSliderCell"
        
        sliderCell.nameLabel.text = "Rate"
        sliderCell.slider.minimumValue = AVSpeechUtteranceMinimumSpeechRate
        sliderCell.slider.maximumValue = AVSpeechUtteranceMaximumSpeechRate
        sliderCell.slider.identifier = 0
        sliderCell.slider.accessibilityIdentifier = "RateSlider"
        
      case 2:
        currentSliderValue = pitch
        
        sliderCell.accessibilityIdentifier = "PitchSliderCell"
        
        sliderCell.nameLabel.text = "Pitch"
        sliderCell.slider.minimumValue = 0.5
        sliderCell.slider.maximumValue = 2.0
        sliderCell.slider.identifier = 1
        sliderCell.slider.accessibilityIdentifier = "PitchSlider"
        
      case 3:
        currentSliderValue = volume
        
        sliderCell.accessibilityIdentifier = "VolumeSliderCell"
        
        sliderCell.nameLabel.text = "Volume"
        sliderCell.slider.minimumValue = 0
        sliderCell.slider.maximumValue = 1
        sliderCell.slider.identifier = 2
        sliderCell.slider.accessibilityIdentifier = "VolumeSlider"
        
      default: break
      }
      
      let slider = sliderCell.slider
      slider.setMaxFractionDigitsDisplayed(2)
      slider.popUpViewColor = FlatSkyBlue()
      slider.autoAdjustTrackColor = false
      slider.textColor = FlatWhite()
      slider.minimumTrackTintColor = FlatSkyBlue()
      slider.thumbTintColor = FlatTeal()
      
      slider.popUpViewCornerRadius = 4.0
      slider.popUpViewArrowLength = 4
      slider.popUpViewHeightPaddingFactor = 1.0
      slider.popUpViewWidthPaddingFactor = 1.1
      
      switch currentDevice {
      case .iPadPro:
        slider.popUpViewCornerRadius = 8.0
        slider.font = UIFont(name: Font.Verdana, size: 46)
        
      case .iPad:
        slider.popUpViewCornerRadius = 8.0
        slider.font = UIFont(name: Font.Verdana, size: 36)
        
      default: break
        
      }
      
      slider.addTarget(self, action: #selector(handleSliderValueChanged(_:)), forControlEvents: .ValueChanged)
      
      if slider.value != currentSliderValue {
        slider.value = currentSliderValue
      }
      
      return sliderCell
      
    }
    
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == 0 {
      switch currentDevice {
      case .iPadPro:
        return 380
      case .iPad:
        return 320
      case .iPhone6Plus, .iPhone6:
        return 240
      case .iPhone4, .iPhone5:
        return 180
      }
    }
    else {
      switch currentDevice {
      case .iPadPro:
        return 200
      case .iPad:
        return 150
      case .iPhone4, .iPhone5, .iPhone6, .iPhone6Plus:
        return 100
      }
    }
  }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return voiceLanguages.count
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let voiceLanguagesDictionary = voiceLanguages[row] as [String: String]
    
    return voiceLanguagesDictionary["languageName"]
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedVoiceLanguageIndex = row
  }
  
  /**
   Retrieve an array of the AVSpeechSynthesis voice available on the current device.
   */
  func prepareVoiceList() {
    for voice in AVSpeechSynthesisVoice.speechVoices() {
      let voiceLanguageCode = voice.language
      
      if let voiceLanguageName = NSLocale.currentLocale().displayNameForKey(NSLocaleIdentifier, value: voiceLanguageCode) {
        
        let dictionary = ["languageName": voiceLanguageName, "languageCode": voiceLanguageCode]
        
        voiceLanguages.append(dictionary)
      }
    }
  }
}






















