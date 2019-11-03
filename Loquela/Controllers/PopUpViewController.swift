//
//  PopUpViewController.swift
//  Loquela
//
//  Created by Daniel Duan on 3/23/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit

// TEXT FIELDS
import TextFieldEffects

// GOOGLE TRANSLATE HELPER
import SwiftGoogleTranslate

class PopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    var delegate: MyProtocol?
    
    var objectName = ""
    var translatedName = ""

    @IBOutlet weak var objectNameTextField: HoshiTextField!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    
    // GOOGLE TRANSLATE API VARIABLES
    var languages = ["Select Language", "Arabic", "Czech", "Danish", "German", "Greek", "Spanish", "Finnish", "French", "Hebrew", "Hindi", "Hungarian", "Indonesian", "Italian", "Japanese", "Korean", "Dutch", "Norwegian", "Polish", "Portugese", "Romanian", "Russian", "Slovak", "Swedish", "Thai", "Turkish", "Chinese"]
    var languageCodes = ["blah", "ar", "cs", "da", "de", "el", "es", "fi", "fr", "he", "hi", "hu", "id", "it", "ja", "ko", "nl", "no", "pl", "pt", "ro", "ru", "sk", "sv", "th", "tr", "zh-CN"]
    var targetCode = "blah"
    var targetLanguage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for google translate cocapod
        SwiftGoogleTranslate.shared.start(with: "API_KEY")
        
        // for popup
        self.definesPresentationContext = true
        
        self.languagePicker.delegate = self
        self.languagePicker.dataSource = self

        // Round Corners
        popUpView.roundCorners(cornerRadius: 10.0)
        translateButton.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 15
        
        // Set initial object name
        objectNameTextField.text = objectName
        
    }
    
    //MARK: - PickerView Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //TODO: alert users if they chose "select row"
        targetCode = languageCodes[row]
        targetLanguage = languages[row]
    }

    //MARK: - Buttons pressed
    
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        var transName = ""

        SwiftGoogleTranslate.shared.translate(objectNameTextField.text ?? "hello", targetCode, "en") { (text, error) in
            if let t = text {
                self.delegate?.createTranslated3DText(englishWord: self.objectNameTextField.text!, newWord: t, languageCode: self.targetCode, language: self.targetLanguage)
            }
            
        }

        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension UIView {
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }
    
}
