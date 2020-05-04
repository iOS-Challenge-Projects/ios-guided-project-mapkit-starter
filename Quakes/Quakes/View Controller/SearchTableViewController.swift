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
    var quakesArray: [Quake] = []
    private var searchActive: Bool = false
    private var filteredQuakes: [Quake] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchActive{
            return filteredQuakes.count
        }else{
            return quakesArray.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quakeCell", for: indexPath)
        
        
        // Configure the cell...
        var quake = quakesArray[indexPath.row]
        
        if searchActive{
            quake = filteredQuakes[indexPath.row]
        }else{
            quake = quakesArray[indexPath.row]
        }

        
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

//MARK: - UISearchBarDelegate

extension SearchTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
     
        filteredQuakes = quakesArray.filter({ (quake) -> Bool in
            
            let tmp: NSString = NSString(string: quake.place)
            
            let range = tmp.range(of: searchText)
            
            return range.location != NSNotFound
        })
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        //Hide keyboard
        searchBar.resignFirstResponder()
    }
}
