//
//  BuildingTableViewController.swift
//  TeamProject
//
//  Created by knuprime103 on 2018. 6. 1..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit

class BuildingTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    let itemTitleDocuments = ["fuck"]
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemTitleDocuments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //set each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMenuCell", for:indexPath)
        cell.textLabel?.text = itemTitleDocuments[indexPath.row] // set the title of a cell
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

  

}
