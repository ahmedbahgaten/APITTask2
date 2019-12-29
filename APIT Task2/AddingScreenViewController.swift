//
//  AddingScreenViewController.swift
//  APIT Task2
//
//  Created by AHMED on 12/29/19.
//  Copyright © 2019 AHMED. All rights reserved.
//

import UIKit
protocol AddingDelegate: class {
    func passingTitleAndBody (Title:String,Body:String)
}
class AddingScreenViewController: UIViewController {
    
    
   
    
    weak var AddDelegate:AddingDelegate?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    
    @IBAction func AddButtonIsTapped(_ sender: Any) {
        guard let Title = titleTextField.text else {return}
        guard let Body = bodyTextField.text else {return}
        AddDelegate?.passingTitleAndBody(Title: Title, Body: Body)
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    
   
       
    



}
