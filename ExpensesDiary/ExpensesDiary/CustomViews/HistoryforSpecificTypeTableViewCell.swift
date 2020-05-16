//
//  HistoryforSpecificTypeTableViewCell.swift
//  ExpensesDiary
//
//  Created by Guido Roberto Carballo Guerrero on 5/16/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

class HistoryforSpecificTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var commentsLB: UILabel!
    @IBOutlet weak var expenseValueLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with comments: String, and value: Float) {
        commentsLB.text = comments
        expenseValueLB.text = String(format: "$%.2f", value)
    }

}
