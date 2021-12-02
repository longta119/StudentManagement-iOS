//
//  EditStudentViewController.swift
//  Assignment2
//
//  Created by qta on 9/10/21.
//

import UIKit

class EditStudentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var textstr = ""
    @IBOutlet weak var studentID: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    var gender: String = ""
    @IBOutlet weak var course: UITextField!
    @IBOutlet weak var ageStepper: UIStepper!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let studentElements = textstr.components(separatedBy: ",")
        studentID.text = studentElements[0]
        firstName.text = studentElements[1]
        lastName.text = studentElements[2]
        gender = studentElements[3]
        if gender == " Male" {
            genderSegmented.selectedSegmentIndex = 0
        } else if gender == " Female" {
            genderSegmented.selectedSegmentIndex = 1
        } else {
            genderSegmented.selectedSegmentIndex = 2
        }
        course.text = studentElements[4]
        age.text = studentElements[5]
        ageStepper.value = 20
        address.text = studentElements[6]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        imageView.image = appDelegate.getStudentImage(id: Int(studentID.text!)!)
        
        studentID.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        course.delegate = self
        address.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    //hide keyboard
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //prepare to pass data to other view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass data to the map view controller
        if let mapViewController = segue.destination as? MapViewController {
            mapViewController.addressmap = address.text!
        }
        
        //pass data (studentID) to the all exam view controller
        if let allExamsViewController = segue.destination as? AllExamsViewController {
            allExamsViewController.textstr = studentID.text!
        }
    }
    
    //select an image from the library
    @IBAction func openPhotoLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //get the required protocol
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    //function to assign a new value to the label when the stpper change its value
    @IBAction func ageChange1(_ sender: Any) {
        var step: Int
        step = Int(ageStepper.value)
        age.text = String(step)
    }
    
    //delete a student record based on the studentID
    @IBAction func deleteRecord(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let alertController = UIAlertController(title: "Warning", message: "Do you want to delete this record?", preferredStyle: .alert)
        let alertAction1 = UIAlertAction(title: "Yes", style: .default) {
            UIAlertAction in
            self.performSegue(withIdentifier: "allStudents", sender: self)
            appDelegate.removeARecord(id: Int(self.studentID.text!)!)        }
        alertController.addAction(alertAction1)
        let alertAction2 = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
    }
    
    //update a student record based on the studentID
    @IBAction func updateRecord(_ sender: Any) {
        //get the AppDelegate object
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if genderSegmented.selectedSegmentIndex == 0 {
            gender = "Male"
        } else if genderSegmented.selectedSegmentIndex == 1 {
            gender = "Female"
        } else {
            gender = "Others"
        }
        
        let jpegImageData = imageView.image!.jpegData(compressionQuality: 1.0)!
        
        //call function storeStudentInfo in AppDelegate
        appDelegate.updateStudentInfo(id: Int(studentID.text!)!, firstname: firstName.text!, lastname: lastName.text!, gender: gender, course: course.text!, age: Int(age.text!)!, address: address.text!, image: jpegImageData)
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
