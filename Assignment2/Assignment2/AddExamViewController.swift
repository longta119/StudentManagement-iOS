//
//  AddExamViewController.swift
//  Assignment2
//
//  Created by qta on 12/10/21.
//

import UIKit

class AddExamViewController: UIViewController, UITextFieldDelegate {

    var textstr = ""
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var location: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        location.delegate = self

        // Do any additional setup after loading the view.
    }
    
    //get the value of date picker and assign it to the label
    @IBAction func dateChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
    
    //add an exam record
    @IBAction func addExam(_ sender: Any) {
        //get the AppDelegate object
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //call function storeExamInfo in appDelegate
        appDelegate.storeExamInfo(id: Int(textstr)!, name: name.text!, date: datePicker.date, location: location.text!)
    }
    
    //hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //pass the data (studentID) to the add exam view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let allExamViewController = segue.destination as? AllExamsViewController {
            allExamViewController.textstr = textstr
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
