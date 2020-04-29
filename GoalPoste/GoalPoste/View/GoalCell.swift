//
//  GoalCell.swift
//  GoalPoste
//
//  Created by bennoui ihab on 4/22/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalDescriptionLbl: UILabel!
    @IBOutlet weak var goalTypeLbl: UILabel!
    @IBOutlet weak var goalProgressLbl: UILabel!
    @IBOutlet weak var CompletionView: UIView!
    
    func configureCell(goal : Goal){
        self.goalDescriptionLbl.text = goal.goalDescriptions
        self.goalTypeLbl.text = goal.goalType
        self.goalProgressLbl.text = String(describing: goal.goalProgress)
        
        if goal.goalProgress == goal.goalCompletionValue {
            self.CompletionView.isHidden = false
        }else {
            self.CompletionView.isHidden = true
        }
    }
    

}
