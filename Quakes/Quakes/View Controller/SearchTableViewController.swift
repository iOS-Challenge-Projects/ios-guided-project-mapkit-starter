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
    var quakesArray: [Quake]?{
        didSet{
            if let quakesArray = quakesArray {
                filtered = quakesArray
            }
        }
    }
    
    private var filtered: [Quake]?
    
    private var selectedQuake: Quake?
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return filtered?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quakeCell", for: indexPath)
        
        
        // Configure the cell...
        if let quake =  filtered?[indexPath.row] {
            
            //Change the color of the marker base on the severaty of the quake
            
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = .white
            
            if let magnitude = quake.magnitude {
                if magnitude >= 5 {
                    cell.detailTextLabel?.textColor = .red
                } else if magnitude >= 3 && magnitude < 5 {
                    cell.detailTextLabel?.textColor = .yellow
                } 
            }
            
            
            cell.textLabel?.text = quake.place
            if let magnitude = quake.magnitude {
                let mag = String(magnitude)
                 cell.detailTextLabel?.text = "Magnitude: \(mag)  Date: 11-11-2010"
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let filtered = filtered {
        selectedQuake = filtered[indexPath.row]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewSegue"{
            guard let detailVC = segue.destination as? DetailViewController else { return }
            DispatchQueue.main.async {
                detailVC.selectedQuake = self.selectedQuake
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //FIXME: Dispose of any resources that can be recreated.
        fatalError("Memory warning")
    }
    
    //MARK: - Custom methods
    func loadItems() {
        
        filtered = quakesArray
        
        tableView.reloadData()
    }
    
    func filterResults(for searchTerm: String) {
        loadItems()
        
        filtered = self.filtered?.filter({ (quake) -> Bool in
            
            let cityName: NSString = NSString(string: quake.place)
            
            let range = cityName.range(of: searchTerm, options: NSString.CompareOptions.caseInsensitive)
            
            return range.location != NSNotFound
        })
        
        //If user clears the searchbar then reload all items
        if searchBar.text?.count == 0 {
            loadItems()
        }
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate

extension SearchTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterResults(for: searchText)
    }
}
