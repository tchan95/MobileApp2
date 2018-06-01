//
//  MenuViewController.swift
//  TeamProject
//
//  Created by apple11 on 2018. 5. 31..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let itemTitleDocuments = ["예약하기","예약 현황 확인"]
    let itemDetailDocuments = ["공유 공간을 예약합니다", "내가 예약한 공간을 확인합니다"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemTitleDocuments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //set each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMenuCell", for:indexPath)
        cell.textLabel?.text = itemTitleDocuments[indexPath.row] // set the title of a cell
        cell.detailTextLabel?.text = itemDetailDocuments[indexPath.row] // set the detail text of a cell
        /**customer Lab11 50:42**/
        //        if let myTVCell = cell as? MenuTableViewCell{
        //            myTVCell
        //        }
        //        print("return")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: itemTitleDocuments[indexPath.row], sender: tableView.cellForRow(at: indexPath))
    }
    @IBOutlet weak var table: UITableView!
    
}
class MenuTableViewCell: UITableViewCell{
    var titleLabel:UILabel?
    var linkLabel: UILabel?
}
