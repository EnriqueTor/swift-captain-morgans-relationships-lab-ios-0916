//
//  PirateTableViewController.swift
//  swift-captain-morgans-relationships-lab
//
//  Created by Enrique Torrendell on 11/11/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class PirateTableViewController: UITableViewController {
    
    let store = DataStore.shareInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if store.pirates.isEmpty {
            store.generateTestData()
        }
        
        self.store.fetchData()

    }
    
//        override func viewDidAppear(_ animated: Bool) {
//            super.viewDidAppear(true)
//            self.store.fetchData()
//            self.tableView.reloadData()
//        }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.pirates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pirateCell", for: indexPath)
        
        cell.textLabel?.text = store.pirates[indexPath.row].name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "shipsSegue" {
            
            if let dest = segue.destination as? ShipTableViewController,
                
                let index = tableView.indexPathForSelectedRow {
                
                dest.ships = store.pirates[index.row].ships?.allObjects as! [Ship]
                
            }
        }
    }
    
}


class ShipTableViewController: UITableViewController {
    
    let store = DataStore.shareInstance
    
    var ships = [Ship]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.ships.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shipCell", for: indexPath)
        
        let ship = store.ships[indexPath.row]
        
        cell.textLabel?.text = ship.name
//        cell.detailTextLabel?.text = ship.pirates?.name
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailsViewController,
            let index = tableView.indexPathForSelectedRow {
            
            dest.ship = ships[index.row]
            
        }
    }
    
    
}

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var shipNameLabel: UILabel!
    
    @IBOutlet weak var pirateNameLabel: UILabel!
    
    @IBOutlet weak var engineLabel: UILabel!
    
    let store = DataStore.shareInstance
    
    var ship: Ship?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shipNameLabel.text = ship?.name
        pirateNameLabel.text = ship?.pirates?.name
        engineLabel.text = ship?.engines?.engineType
        
    }
    
}


