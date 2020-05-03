//
//  SettingsVehicleViewController.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 4/21/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

class SettingsVehicleViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var modelTF: UITextField!
    @IBOutlet weak var plateTF: UITextField!
    @IBOutlet weak var vinTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    //@IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: ConfigurableButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var vehicle : Vehicle!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        //self.hideKeyboard()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if vehicle != nil {
            nameTF.text = vehicle.name
            
            if let model = vehicle.model {
                modelTF.text = model
            }
            
            if let plate = vehicle.plate {
                plateTF.text = plate
            }
            
            if let vin = vehicle.vin {
                vinTF.text = vin
            }
            
            if let titleNum = vehicle.titleNumber {
                titleTF.text = titleNum
            }
        }
        
        nameTF.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func onKeyboardAppear(_ notification: NSNotification) {
        
        print("keyboard is showing")
        
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        print("kbSize.height: \(kbSize.height)")

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        print("insets: \(insets)")
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets

        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        var aRect = self.view.frame;
        print("Original aRect.size.height: \(aRect.size.height)")
        aRect.size.height -= kbSize.height;
        print("aRect.size.height - kbSize.height: \(aRect.size.height)")

        let activeField: UITextField? = [nameTF, modelTF, plateTF, vinTF, titleTF].first { $0.isFirstResponder }
        if let activeField = activeField {
            print("textfield.frame.origin: \(activeField.frame.origin)")
            if !aRect.contains(activeField.frame.origin) {
                print("textfield under keyboard")
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }

    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        
        print("keyboard is hiding")
        
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    /*@objc func keyboardWillShow(notification: NSNotification) {
        
        if vinTF.isFirstResponder || titleTF.isFirstResponder {
            
            /*guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

            let keyboardScreenEndFrame = keyboardValue.cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
            
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            
            let scrollTo = saveButton.frame.origin
            scrollView.setContentOffset(scrollTo, animated: true)*/
            scrollView.scrollTo(direction: .Bottom)
            
            //saveButtonBottomConstraint.constant = keyboardViewEndFrame.height + 5
            
        }
        
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
        //saveButtonBottomConstraint.constant = 0
        
    }
    
    @IBAction func saveVehicle(_ sender: UIButton) {
        
        if vehicle == nil {
            vehicle = Vehicle(context: context)
        }
        
        if let name = checkTF(textField: nameTF, errorMes: "You need to select a name for this vehicle.") {
            
            vehicle.name = name
            
            if let model = checkTF(textField: modelTF, errorMes: nil) {
                vehicle.model = model
            }
            
            if let plate = checkTF(textField: plateTF, errorMes: nil) {
                vehicle.plate = plate
            }
            
            if let vin = checkTF(textField: vinTF, errorMes: nil) {
                vehicle.vin = vin
            }
            
            if let titleNum = checkTF(textField: titleTF, errorMes: nil) {
                vehicle.titleNumber = titleNum
            }
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            navigationController?.popViewController(animated: true)
            
        }
    }

}

extension SettingsVehicleViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            case nameTF:
                modelTF.becomeFirstResponder()
            case modelTF:
                plateTF.becomeFirstResponder()
            case plateTF:
                vinTF.becomeFirstResponder()
            case titleTF:
                view.endEditing(true)
            default:
                titleTF.becomeFirstResponder()
        }
        
        return true
    }
    
    /*func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }*/
}
