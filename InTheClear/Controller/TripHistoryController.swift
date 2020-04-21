//
//  TripHistoryController.swift
//  InTheClear
//
//  Created by Josh Sauder on 4/20/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import UIKit

class TripHistoryController: UITableViewController {
    
    var tripDataArray: [TripHistory] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripDataArray.count
    }
    
    
}
