//
//  CreatGoalVCViewController.swift
//  GoalPoste
//
//  Created by bennoui ihab on 4/23/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import UIKit

class CreatGoalVC: UIViewController , UITextViewDelegate {

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var ShortTermBtn: UIButton!
    @IBOutlet weak var LongTermBtn: UIButton!
    
    var goalType : GoalType = .shortTerm
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        ShortTermBtn.setSelectedColor()
        LongTermBtn.setDeselectedColor()
        goalTextView.delegate = self
    }
    
    
    func setButton(){
        
    let NextBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
    NextBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
    NextBtn.setTitle("NEXT", for: .normal)
    NextBtn.addTarget(self, action: #selector(CreatGoalVC.NextAction), for: .touchUpInside)
    goalTextView.inputAccessoryView = NextBtn
    }
   
    @objc func NextAction() {
        if goalTextView.text != "" && goalTextView.text != "What is your Goal ?   " {
            guard let finishGoalVC = storyboard?.instantiateViewController(withIdentifier: "FinishGoalVC") as? FinishGoalVC else { return }
            
            finishGoalVC.initData(description: goalTextView.text!, type: goalType)
            presentingViewController?.presentSecondDetail(finishGoalVC)
        }
    }
    
    
    
    @IBAction func ShortTermBtnWaspressed(_ sender: Any) {
        goalType = .shortTerm
        ShortTermBtn.setSelectedColor()
        LongTermBtn.setDeselectedColor()
    }
    
    @IBAction func LongTermBtnWaspressed(_ sender: Any) {
        goalType = .longTerm
        LongTermBtn.setSelectedColor()
        ShortTermBtn.setDeselectedColor()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        dismissDetail()
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        goalTextView.text = ""
        goalTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
}
