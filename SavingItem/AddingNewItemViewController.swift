import UIKit
protocol savingViewProtocol:class {
    func handleScreenState()
    func handleAdding()
    func handleUpdate()
    func circularSavingButton()
}
protocol SavingDelegateProtocol: class {
    func passingTitleAndBody (Title:String,Body:String,state:screenState)
}
class SavingScreenViewController: UIViewController {
    //MARK:-Variables
    weak var SavingDelegate:SavingDelegateProtocol?
    var selectedItem: ServerResponse?
    var state: screenState  = .add
    var savingViewP:savingViewProtocol!
    //MARK:-Outlets
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    //MARK:-Actions
    @IBAction func savingButtonIsTapped(_ sender: Any) {
          guard let Title = titleTextView.text else {return}
          guard let Body = bodyTextView.text else {return}
          SavingDelegate?.passingTitleAndBody(Title: Title, Body: Body,state:state)
          dismiss(animated: true, completion: nil)
      }
    //MARK:-Didload function
    override func viewDidLoad() {
        super.viewDidLoad()
        handleScreenState()
        circularSavingButton()
        self.hideKeyboardWhenTappedAround()
//        presenter = savingPresenterImplementation(savingView: savingViewP)
        
    }
    //MARK:-Functions
     func handleScreenState(){
        switch state {
        case .add:
            handleAdding()
        case .update:
            handleUpdate()
        }
    }
      func handleAdding() {
        titleTextView.text = ""
        bodyTextView.text = ""
        saveButton.setTitle("Add", for: .normal)
    }
     func handleUpdate(){
        titleTextView.text = selectedItem?.title
        bodyTextView.text = selectedItem?.body
        saveButton.setTitle("Update", for: .normal)
    }
     func circularSavingButton () {
        saveButton.layer.cornerRadius = saveButton.layer.frame.size.width / 2
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowRadius = 3.0
        saveButton.layer.shadowOpacity = 0.8
        saveButton.layer.shadowOffset = CGSize(width: 0.0 , height: 3.0)
    }
  
}
//MARK:-Handling screen state
enum screenState{
    case update
    case add
}
