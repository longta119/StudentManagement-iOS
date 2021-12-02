//
//  AddStudentViewController.swift
//  Assignment2
//
//  Created by qta on 8/10/21.
//

import UIKit

class AddStudentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var studentID: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    var gender : String = ""
    @IBOutlet weak var course: UITextField!
    @IBOutlet weak var ageStepper: UIStepper!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var address: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        studentID.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        course.delegate = self
        address.delegate = self
        let image1 : UIImage = UIImage(named: "Logo.jpg")!
        imageView.image = image1

        // Do any additional setup after loading the view.
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
    
    //get the value of the stepper
    @IBAction func ageChange(_ sender: Any) {
        var step: Int
        step = Int(ageStepper.value)
        age.text = String(step)
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
    
    //add a student record
    @IBAction func addStudent(_ sender: Any) {
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
        appDelegate.storeStudentInfo(id: Int(studentID.text!)!, firstname: firstName.text!, lastname: lastName.text!, gender: gender, course: course.text!, age: Int(age.text!)!, address: address.text!, image: jpegImageData)
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
