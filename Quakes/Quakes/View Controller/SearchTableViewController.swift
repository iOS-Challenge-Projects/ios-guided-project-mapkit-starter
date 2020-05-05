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
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationController?.popViewController(animated: true)
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
