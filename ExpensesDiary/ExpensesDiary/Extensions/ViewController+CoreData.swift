//
//  ViewController+CoreData.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 4/20/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    enum MapMessageType {
        case noDataFound
        case authorizationWarning
        case dataSaved
        case errorSavingData
        case locationDisable
    }
    
    
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        view.endEditing(true)
    }
    
    /*func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }*/
    
    func showMessage(type: MapMessageType, message: String, title: String = "Error") {
        
        //let title = "Error"
        let alert: UIAlertController!
        let cancelAction: UIAlertAction!
        
        switch type {
            
        case .noDataFound, .errorSavingData:
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: nil))
        
        case .dataSaved:
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
        case .authorizationWarning, .locationDisable:
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "Go to Settings", style: .default, handler: { (action) in
                
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            })
            alert.addAction(confirmAction)
            
        }
        
        /*let title = type == .authorizationWarning ? "FYI" : "Error"
        let message = type == .authorizationWarning ? "If Location is authorize for this app at Settings/Privacy/Location Services your location will be saved for each expense." : "The Location is not available."*/
        
        
        present(alert, animated: true, completion: nil)
    }
    
    func checkTF(textField: UITextField, errorMes: String?) -> String? {
        
        if let tfString = textField.text, tfString.count > 0 {
            return tfString
        } else if errorMes != nil {
            showMessage(type: .noDataFound, message: errorMes!)
        }
        
        return nil
    }
    
}
