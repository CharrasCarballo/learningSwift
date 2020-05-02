//
//  ConfigurableButton.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 4/19/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

@IBDesignable
class ConfigurableButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
        self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
