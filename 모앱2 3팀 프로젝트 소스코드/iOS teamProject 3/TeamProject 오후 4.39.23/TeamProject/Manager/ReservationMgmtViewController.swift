//
//  ReservationMgmtViewController.swift
//  TeamProject
//
//  Created by apple11 on 2018. 6. 7..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit

class ReservationMgmtViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table : UITableView!
    
    var isloaded : Bool = false
    var reservationInfo: [[String: AnyObject]] = []
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
        self.table.register(UINib(nibName: "ReservationMgmtTableViewCell", bundle: nil), forCellReuseIdentifier: "ReservationMgmtTableViewCell")
    }
    override func loadView(){
        super.loadView()
        if !isloaded{
            self.spinner.startAnimating()
            HttpHelper.Shared.Get(path: URLREQUEST.reservation_mg_get.rawValue, success: {
                (result : String) in
                let data = result.data(using:.utf8)!
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Dictionary<String, Any>]{
                        DispatchQueue.main.async {
                            for i in 0..<json.count{
                                var temp :[String: AnyObject] = [:]
                                temp[COOKEYS.reservation_no.rawValue] = json[i][COOKEYS.reservation_no.rawValue] as AnyObject
                                temp[COOKEYS.name.rawValue] = json[i][COOKEYS.name.rawValue] as AnyObject
                                temp[COOKEYS.s_id.rawValue] = json[i][COOKEYS.s_id.rawValue] as AnyObject
                                temp[COOKEYS.dpt.rawValue] = json[i][COOKEYS.dpt.rawValue] as AnyObject
                                temp[COOKEYS.dpt_name.rawValue] = json[i][COOKEYS.dpt_name.rawValue] as AnyObject
                                temp[COOKEYS.room.rawValue] = json[i][COOKEYS.room.rawValue] as AnyObject
                                temp[COOKEYS.date.rawValue] = (json[i]["DATE"] as! String)[0..<10] as AnyObject
                                temp[COOKEYS.start_time.rawValue] = json[i]["S_TIME"] as AnyObject
                                temp[COOKEYS.end_time.rawValue] = json[i]["F_TIME"] as AnyObject
                                temp[COOKEYS.reservation_state.rawValue] = json[i][COOKEYS.reservation_state.rawValue] as AnyObject
                                
                                self.reservationInfo.append(temp)
                            }
                            
                            self.isloaded = true
                            self.table.reloadData()
                            self.spinner.stopAnimating()
                        }
                    }else{
                        print("error!")
                        DispatchQueue.main.async {
                            self.spinner.stopAnimating()
                        }
                    }
                }catch let err as NSError{
                    print(err)
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                    }
                }
                print(result)
            }, failure: {
                (error: String) in
                print("loading building data error")
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationInfo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //set each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationMgmtTableViewCell", for:indexPath) as! ReservationMgmtTableViewCell
        cell.nameLabel.text = reservationInfo[indexPath.row][COOKEYS.name.rawValue] as? String
        cell.sidLabel.text = reservationInfo[indexPath.row][COOKEYS.s_id.rawValue] as? String
        cell.locaLabel.text = String(format: "%@ %@ %@", reservationInfo[indexPath.row][COOKEYS.dpt.rawValue] as! String,
                                     reservationInfo[indexPath.row][COOKEYS.dpt_name.rawValue] as! String,
                                     reservationInfo[indexPath.row][COOKEYS.room.rawValue] as! String)
        cell.dateLabel.text = reservationInfo[indexPath.row][COOKEYS.date.rawValue] as? String
        cell.timeLabel.text = String(format: "%@ ~ %@", reservationInfo[indexPath.row][COOKEYS.start_time.rawValue] as! String,
                                     reservationInfo[indexPath.row][COOKEYS.end_time.rawValue] as! String)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let permission = UITableViewRowAction(style: .normal,
                                       title: "승인") {
                                        (action, index) in
                                        print("승인 \(index.row)")
                                        let body = String(format: "%@=%d",
                                                          COOKEYS.reservation_no.rawValue, self.reservationInfo[index.row][COOKEYS.reservation_no.rawValue] as! Int
                                        )
                                        HttpHelper.Shared.Post(path: URLREQUEST.reservation_mg_permission.rawValue,
                                                               paras: body,
                                                               success: {
                                                                (result: String) in
                                                                
                                                                DispatchQueue.main.async {
                                                                    self.spinner.stopAnimating()
                                                                }
                                        },
                                                               failure: { (err:String) in
                                                                
                                                                DispatchQueue.main.async {
                                                                    self.spinner.stopAnimating()
                                                                }
                                        })
                                        DispatchQueue.main.async {
                                            self.spinner.startAnimating()
                                        }
                                        self.alertShow(title: "예약을 승인하였습니다.")
        }
        permission.backgroundColor = UIColor.blue
        let denied = UITableViewRowAction(style: .normal,
                                          title: "거부") {
                                            (action, index) in
                                            print("거부 \(index.row)")
                                            let body = String(format: "%@=%d",
                                                              COOKEYS.reservation_no.rawValue, self.reservationInfo[index.row][COOKEYS.reservation_no.rawValue] as! Int
                                            )
                                            HttpHelper.Shared.Post(path: URLREQUEST.reservation_mg_denied.rawValue,
                                                                   paras: body,
                                                                   success: {
                                                                    (result: String) in
                                                                    
                                                                    DispatchQueue.main.async {
                                                                        self.spinner.stopAnimating()
                                                                    }
                                            },
                                                                   failure: { (err:String) in
                                                                    
                                                                    DispatchQueue.main.async {
                                                                        self.spinner.stopAnimating()
                                                                    }
                                            })
                                            DispatchQueue.main.async {
                                                self.spinner.startAnimating()
                                            }
                                            self.alertShow(title: "예약을 거부하였습니다.")
                                            
        }
        denied.backgroundColor = UIColor.red
        
        return [denied, permission] // display ： permission-denied
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
extension UIViewController{
    func alertShow(title: String){
        let alertView = UIAlertView(title: nil, message: title, delegate: nil, cancelButtonTitle: "확인")
        alertView.show()
    }
}


