//
//  GoalsVC .swift
//  GoalPoste
//
//  Created by bennoui ihab on 4/19/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {
    
    
    //Variables :
    var goals = [Goal]()
    var lastRemovedGoalDesc : String?
    var lastRemovedGoalType: String?
    var lastRemovedGoalCompletionValue: Int32?
    var lastRemovedGoalProgress: Int32?
    
    @IBOutlet weak var TableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
        TableView.isHidden = false 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCoreDataObjects()
        TableView.reloadData()
            }
    
//fetch function
    func fetchCoreDataObjects(){
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    TableView.isHidden = false
                } else { TableView.isHidden = true }
            }
        }
    }
    
    
    
    
    //Undo Protocolos for the Delete ACtions
    @IBOutlet weak var UndoView: UIView!
    @IBAction func UndoBtnWasPressed(_ sender: Any) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
               
               let oldGoal = Goal(context: managedContext)
               oldGoal.goalDescriptions = lastRemovedGoalDesc
               oldGoal.goalType = lastRemovedGoalType
               oldGoal.goalCompletionValue = lastRemovedGoalCompletionValue!
               oldGoal.goalProgress = lastRemovedGoalProgress!
               do {
                   try managedContext.save()
                   UndoView.isHidden = true
                //setup the new tableView
                   fetchCoreDataObjects()
                   TableView.reloadData()
                
                   print("Successfully undo'd")
               } catch {
                   debugPrint("Could not undo \(error.localizedDescription)")
               }
    }
    
    
    
    @IBAction func AddGoalBtnWasPressed (_ sender : Any){
        guard let createGoslVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else {
            return
        }
        presentDetail(createGoslVC)
    }
}

// MARK : Extensions

// Table View Deelegates Protocols
extension GoalsVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell") as? GoalCell else {
            return UITableViewCell()}
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
    
                self.removeGoal(atIndexPath: indexPath)
                self.fetchCoreDataObjects()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.UndoView.isHidden = false
            }
        let addAction = UITableViewRowAction(style: .normal, title: "Add") { (addAction, indexPath) in
            self.setProgresse(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
            deleteAction.backgroundColor =  #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            addAction.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
            return [deleteAction , addAction]
        }
        
    }

// MARK : DATA FETCH -->
extension GoalsVC {
    func setProgresse(atIndexPath indexPath : IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        
        let chosenGoal = goals[indexPath.row]
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress = chosenGoal.goalProgress + 1
        }else {return}
        
        do {
            try managedContext.save()
            print("succufully added !")
        }catch {
            debugPrint("Could not set progress : \(error.localizedDescription)")
        }
    }
    
    
    func removeGoal(atIndexPath indexPath : IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(goals[indexPath.row])
        
        // Delete goal
        let delGoal = goals[indexPath.row]
        
        lastRemovedGoalDesc = delGoal.goalDescriptions
        lastRemovedGoalType = delGoal.goalType
        lastRemovedGoalCompletionValue = delGoal.goalCompletionValue
        lastRemovedGoalProgress = delGoal.goalProgress
        
        do{
            try managedContext.save()
            print("succuffuly deleted")
        }catch {
            debugPrint("Could not delete : \(error.localizedDescription)")
        }
    }
    
    
    func fetch(completion :(_ complete : Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
           goals =  try managedContext.fetch(fetchRequest)
            completion(true)
        }catch{
            debugPrint("Could not fetch : \(error.localizedDescription)")
            completion(false)
        }
    }
}
