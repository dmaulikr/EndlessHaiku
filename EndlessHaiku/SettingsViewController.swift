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
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    print("SettingsVC")
    
    rate = defaults.floatForKey(UserDefaultsKey.rate)
    pitch = defaults.floatForKey(UserDefaultsKey.pitch)
    volume = defaults.floatForKey(UserDefaultsKey.volume)
    selectedVoiceLanguageIndex = defaults.integerForKey(UserDefaultsKey.languageCodeIndex)
    
    print("rate \(rate), pitch \(pitch)")
    
    
    title = "Settings"
    let barButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveAction")
    navigationItem.rightBarButtonItem = barButton
    
    prepareVoiceList()
  }
  
  // MARK: Properties
  var rate: Float = 0
  var pitch: Float = 1.0
  var volume: Float = 1.0
  let defaults = NSUserDefaults.standardUserDefaults()
  
  var voiceLanguages = [[String:String]]()
  var selectedVoiceLanguageIndex: Int = 8
  
  weak var delegate: SettingsViewControllerDelegate?
  
  var adView: MPAdView?
  
}

extension SettingsViewController {
  
  // MARK: Functions
  
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
      
      pickerCell.pickerView.delegate = self
      pickerCell.pickerView.dataSource = self
      
      pickerCell.pickerView.showsSelectionIndicator = true
      pickerCell.pickerView.selectRow(selectedVoiceLanguageIndex, inComponent: 0, animated: true)
      
      return pickerCell
      
    } else {
      
      let sliderCell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as! CustomSliderTableViewCell
      
      var currentSliderValue: Float = 0
      
      switch indexPath.row {
      case 1:
        currentSliderValue = rate
        
        sliderCell.nameLabel.text = "Rate"
        sliderCell.slider.minimumValue = AVSpeechUtteranceMinimumSpeechRate
        sliderCell.slider.maximumValue = AVSpeechUtteranceMaximumSpeechRate
        sliderCell.slider.identifier = 0
        
      case 2:
        currentSliderValue = pitch
        
        sliderCell.nameLabel.text = "Pitch"
        sliderCell.slider.minimumValue = 0.5
        sliderCell.slider.maximumValue = 2.0
        sliderCell.slider.identifier = 1
        
      case 3:
        currentSliderValue = volume
        
        sliderCell.nameLabel.text = "Volume"
        sliderCell.slider.minimumValue = 0
        sliderCell.slider.maximumValue = 1
        sliderCell.slider.identifier = 2
        
      default: break
      }
      
      let slider = sliderCell.slider
      slider.popUpViewCornerRadius = 4.0
      slider.setMaxFractionDigitsDisplayed(2)
      slider.popUpViewColor = FlatSkyBlue()
      slider.autoAdjustTrackColor = false
      slider.textColor = FlatWhite()
      slider.minimumTrackTintColor = FlatSkyBlue()
      slider.thumbTintColor = FlatTeal()
      slider.popUpViewArrowLength = 4
      slider.popUpViewHeightPaddingFactor = 1.0
      slider.popUpViewWidthPaddingFactor = 1.1
      
      slider.addTarget(self, action: "handleSliderValueChanged:", forControlEvents: .ValueChanged)
      
      if slider.value != currentSliderValue {
        slider.value = currentSliderValue
      }
      
      return sliderCell
      
    }
    
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 160.0
    }
    else{
      return 100.0
    }
  }
}

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

extension SettingsViewController: MPAdViewDelegate {
  func viewControllerForPresentingModalView() -> UIViewController! {
    return self
  }
}























