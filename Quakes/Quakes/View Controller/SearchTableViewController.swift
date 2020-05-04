//
//  SearchTableTableViewController.swift
//  Quakes
//
//  Created by FGT MAC on 5/4/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    //MARK: - Properties
    var quakesArray: [Quake]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quakesArray?.count ?? 1
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quakeCell", for: indexPath)

        if let quakesArray = quakesArray  {
            // Configure the cell...
            let quake = quakesArray[indexPath.row]
            
            //Change the color of the marker base on the severaty of the quake
            
            if let magnitude = quake.magnitude {
                if magnitude >= 5 {
                    cell.backgroundColor  = .red
                } else if magnitude >= 3 && magnitude < 5 {
                    cell.backgroundColor = .orange
                }else{
                    cell.backgroundColor = .yellow
                }
            }else{
                //If there is no magnitude set to white
               cell.backgroundColor = .white
            }
            
            let magnitude = String(quake.magnitude!)
            
            cell.textLabel?.text = quake.place
            cell.detailTextLabel?.text = magnitude
            
            
        }

        return cell
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
