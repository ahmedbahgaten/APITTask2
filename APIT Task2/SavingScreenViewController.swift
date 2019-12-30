import UIKit

protocol SavingDelegateProtocol: class {
    func passingTitleAndBody (Title:String,Body:String,state:screenState)
}

class SavingScreenViewController: UIViewController {
    
    weak var SavingDelegate:SavingDelegateProtocol?
    var selectedItem: ServerResponse?
    var state: screenState  = .add
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        handleScreenState()
        circularSavingButton()
    }
    private func handleScreenState(){
        switch state {
        case .add:
            handleAdding()
        case .update:
            handleUpdate()
        }
    }
    private  func handleAdding() {
        titleTextField.text = ""
        bodyTextField.text = ""
        saveButton.setTitle("Add", for: .normal)
        
    }
    private func handleUpdate(){
        titleTextField.text = selectedItem?.title
        bodyTextField.text = selectedItem?.body
        saveButton.setTitle("update", for: .normal)
    }
    func circularSavingButton () {
        saveButton.layer.cornerRadius = saveButton.layer.frame.size.width / 2
        
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowRadius = 3.0
        saveButton.layer.shadowOpacity = 0.8
        saveButton.layer.shadowOffset = CGSize(width: 0.0 , height: 3.0)
        
    }
    
    @IBAction func savingButtonIsTapped(_ sender: Any) {
        guard let Title = titleTextField.text else {return}
        guard let Body = bodyTextField.text else {return}
        SavingDelegate?.passingTitleAndBody(Title: Title, Body: Body,state:state)
        dismiss(animated: true, completion: nil)
    }
    
}
enum screenState{
    case update
    case add
}
