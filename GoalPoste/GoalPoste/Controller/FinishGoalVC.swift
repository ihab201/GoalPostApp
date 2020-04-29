//
//  FinishGoalVC.swift
//  GoalPoste
//
//  Created by bennoui ihab on 4/25/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import UIKit
import CoreData

class FinishGoalVC: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var FinishGoalBtn: UIButton!
    
    var goalType : GoalType!
    var goalDescription : String!
    
    func initData (description: String , type : GoalType){
        self.goalType = type
        self.goalDescription = description
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FinishGoalBtn.bindToKeyboard()
        pointsTextField.delegate = self
    }
    @IBAction func FinishGoalBtnWasPressed(_ sender: Any) {
        if pointsTextField.text != "" {
            self.save { (completion) in
                if completion {
                    dismiss(animated: true , completion: nil)
                }
            }
        }
    }
        
    @IBAction func backButtonWasPressed(_ sender: Any) {
        dismissDetail()
    }
    
    //MARK : Save Data 
    func save(completion : (_ finished : Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context : managedContext)
        goal.goalType = goalType.rawValue
        goal.goalDescriptions = goalDescription
        goal.goalProgress = Int32(0)
        goal.goalCompletionValue = Int32(pointsTextField.text!)!
        
        
        do {
            try managedContext.save()
            print("succufully saved data")
            completion(true)
            
        }catch {
            debugPrint("Could not save \(error.localizedDescription)")
            completion(false)
        }
    }
}
