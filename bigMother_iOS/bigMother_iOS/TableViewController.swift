//
//  TableViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-09-24.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var options = ["Enable Recurring Updates", "Recurring Settings", "Add New Subject"]
    var subjects = ["Curtis", "Aidan", "Bella", "Francis"]
    var sections = ["Options", "Manage Subjects"]
    
    var sizes: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        let optionSize: Int = options.count;
        let subjectSize: Int = subjects.count;
        
        sizes = [optionSize, subjectSize]


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0

        if section < sizes.count {
            rows = sizes[section]
        }

        return rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        if (indexPath.section == 0) {

            //cell.textLabel?.text = options[indexPath.row]
            let option = options[indexPath.row]
            cell.textLabel?.text = option
//            cell.imageView?.image = UIImage(named: "calendar")
            
        } else if (indexPath.section == 1) {
            cell.textLabel?.text = subjects[indexPath.row]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         // Ensure that this is a safe cast
           if let secNames = sections as? [String]
           {
               return secNames[section]
           }

           // This should never happen, but is a fail safe
           return "unknown"
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
