//
//  BaseViewController.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 5/3/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var listOfTextFields: [UITextField] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        hideKeyboard()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

        let activeField: UITextField? = listOfTextFields.first { $0.isFirstResponder }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BaseViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if var indexTextField = listOfTextFields.firstIndex(of: textField)  {
            indexTextField += 1
            if indexTextField  < listOfTextFields.count {
                listOfTextFields[indexTextField].becomeFirstResponder()
            } else if indexTextField  == listOfTextFields.count {
                view.endEditing(true)
            }
        }
        
        return true
    }
    
}
