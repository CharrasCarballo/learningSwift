//
//  MemoryViewController.swift
//  Memorias
//
//  Created by Guido Roberto Carballo Guerrero on 8/4/20.
//

import UIKit

class MemoryViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
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
