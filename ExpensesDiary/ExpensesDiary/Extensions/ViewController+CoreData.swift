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
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}
