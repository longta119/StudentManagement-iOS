//
//  AllExamsViewController.swift
//  Assignment2
//
//  Created by qta on 12/10/21.
//

import UIKit

class AllExamsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //return the size of the array to the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let recordRows = appDelegate.getExamInfo(id: Int(textstr)!).components(separatedBy: "\n")
        return recordRows.count
    }
    
    //asign the values in your array variable to cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let recordRows = appDelegate.getExamInfo(id: Int(textstr)!).components(separatedBy: "\n")
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell1", for: indexPath)
        cell.textLabel!.text = recordRows[indexPath.row]
        return cell
    }
    
    var textstr = ""
    var cell = ""
    var cell1 = ""
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textCell: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "All Exams Associated with Student " + textstr
        tableView.allowsMultipleSelection = true

        // Do any additional setup after loading the view.
    }
    
    //pass data (studentID) back to the all exam view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addExamViewController = segue.destination as? AddExamViewController {
            addExamViewController.textstr = textstr
        }
    }
    
    //register when user tap a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let recordRows = appDelegate.getExamInfo(id: Int(textstr)!).components(separatedBy: "\n")
        
        if let indexPaths = tableView.indexPathsForSelectedRows {
            let sortedArray = indexPaths.sorted{$0.row > $1.row}
            for i in (0...sortedArray.count-1).reversed() {
                cell = recordRows[sortedArray[i].row] + "\n"
            }
            cell1 = cell1 + cell
        }
        textCell.text! = cell1
    }
    
    //delete multiple exam record based on the exam name
    @IBAction func deleteExam(_ sender: Any) {
        let showResult = textCell.text!
        let resultRow = showResult.components(separatedBy: "\n")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        for i in (0...resultRow.count-2) {
            let resultName = resultRow[i].components(separatedBy: ",")
            appDelegate.removeExamRecord(name: resultName[0])
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
