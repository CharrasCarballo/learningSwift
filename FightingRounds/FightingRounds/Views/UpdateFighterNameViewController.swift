//
//  UpdateFighterNameViewController.swift
//  FightingRounds
//
//  Created by Guido Roberto Carballo Guerrero on 6/20/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

class UpdateFighterNameViewController: UIViewController {

    @IBOutlet weak var UpdateButton: UIButton!
    @IBOutlet weak var fighterNameTF: UITextField!
    
    let fightersInfo = MatchingPairs.shared
    
    var fighterNames: [String] = []
    var indexForFighterName: Int = 0
    var initialFighterName: String = "Rickson"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpdateButton.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("name of fighter when viewWillAppear: \(initialFighterName)")
        fighterNames = fightersInfo.returnAllFighterNames()
        indexForFighterName = fighterNames.firstIndex(of: initialFighterName)!
        fighterNameTF.text = initialFighterName
    }
    
    func setFighter(name: String) {
        initialFighterName = name
    }
    
    @IBAction func updateName(_ sender: UIButton) {
        
        if fighterNameTF.text?.count ?? 0 > 0 {
            fighterNames[indexForFighterName] = fighterNameTF.text!
            fightersInfo.setFighterNames(names: fighterNames)
            navigationController?.popViewController(animated: true)
        } else {
            let alert: UIAlertController!
            alert = UIAlertController(title: "Empty fighter name", message: "You need to type the name of you fighter", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        
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
