//
//  AllStudentsViewController.swift
//  Assignment2
//
//  Created by qta on 8/10/21.
//

import UIKit

class AllStudentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //return the size of the array to the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let recordRows = appDelegate.getStudentInfo().components(separatedBy: "\n")
        return recordRows.count
    }
    
    //assign the values in your array variable to cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let recordRows = appDelegate.getStudentInfo().components(separatedBy: "\n")
            
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            cell.textLabel!.text = recordRows[indexPath.row]
            return cell
    }
    
    //register when user tap a cell via alert message
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let recordRows = appDelegate.getStudentInfo().components(separatedBy: "\n")
        cell = recordRows[indexPath.row]

        let alertController = UIAlertController(title: "Action", message: "Do you want to edit this '\(recordRows[indexPath.row])' record?", preferredStyle: .alert)
        let alertAction1 = UIAlertAction(title: "Yes", style: .default) {
            UIAlertAction in
            self.performSegue(withIdentifier: "editStudent", sender: self)
        }
        alertController.addAction(alertAction1)
        let alertAction2 = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
    }
    
    //pass data to the edit student page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editStudentViewController = segue.destination as? EditStudentViewController {
            editStudentViewController.textstr = cell
        }
    }

    @IBOutlet weak var studentTable: UITableView!
    var cell = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
