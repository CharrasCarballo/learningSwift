//
//  Timer.swift
//  TrainingTimer
//
//  Created by Guido R Carballo G on 6/2/19.
//  Copyright © 2019 Guido R Carballo G. All rights reserved.
//

import Foundation
import UIKit

enum UserDefaultsKeys: String {
    case roundMinutes = "minutes"
    case roundSeconds = "seconds"
    case breakMin = "breakMin"
    case breakSec = "breakSec"
}

class RoundTimerSettings {
    
    let defaults = UserDefaults.standard
    static var shared: RoundTimerSettings = RoundTimerSettings()
    
    var roundMinutes: Int {
        get {
            return defaults.integer(forKey: UserDefaultsKeys.roundMinutes.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.roundMinutes.rawValue)
        }
    }
    
    var roundSeconds: Int {
        get {
            return defaults.integer(forKey: UserDefaultsKeys.roundSeconds.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.roundSeconds.rawValue)
        }
    }
    
    var breakMin: Int {
        get {
            return defaults.integer(forKey: UserDefaultsKeys.breakMin.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.breakMin.rawValue)
        }
    }
    
    var breakSec: Int {
        get {
            return defaults.integer(forKey: UserDefaultsKeys.breakSec.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.breakSec.rawValue)
        }
    }
    
    private init() {
        if defaults.integer(forKey: UserDefaultsKeys.roundMinutes.rawValue) == 0 && defaults.integer(forKey: UserDefaultsKeys.roundSeconds.rawValue) == 0 {
            defaults.set(5.0, forKey: UserDefaultsKeys.roundMinutes.rawValue)
        }
        
        if defaults.integer(forKey: UserDefaultsKeys.breakMin.rawValue) == 0 && defaults.integer(forKey: UserDefaultsKeys.breakSec.rawValue) == 0 {
            defaults.set(1.0, forKey: UserDefaultsKeys.breakMin.rawValue)
        }
    }
    
}
