//
//  SubmitReservationViewController.swift
//  TeamProject
//
//  Created by apple11 on 2018. 6. 6..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit

class SubmitReservationViewController: UIViewController {
    var delegate : ValueTransDelegate?
    var submitValue : [String: AnyObject]?
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var dptLabel : UILabel!
    @IBOutlet weak var dpt_nameLabel : UILabel!
    @IBOutlet weak var s_idLabel : UILabel!
    @IBOutlet weak var roomLabel : UILabel!
    @IBOutlet weak var startTimeLabel : UILabel!
    @IBOutlet weak var endTimeLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    var nameText: String?{
        didSet{
            nameLabel.text = nameText ?? "unknown"
        }
    }
    var dptText: String?{
        didSet{
            dptLabel.text = dptText ?? "unknown"
        }
    }
    var dpt_nameText: String?{
        didSet{
            dpt_nameLabel.text = dpt_nameText ?? "unknown"
        }
    }
    var s_idText : String?{
        didSet{
            s_idLabel.text = s_idText ?? "unknown"
        }
    }
    var roomText : String?{
        didSet{
            roomLabel.text = roomText ?? "unknown"
        }
    }
    var startTimeText: String?{
        didSet{
            startTimeLabel.text = startTimeText ?? "unknown"
        }
    }
    var endTimeText: String?{
        didSet{
            endTimeLabel.text = endTimeText ?? "unknown"
        }
    }
    var dateText: String?{
        didSet{
            dateLabel.text = dateText ?? "unknown"
        }
    }
    func createSubmitBody()->String{
        return String(format: "%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",
                      COOKEYS.dpt.rawValue, self.submitValue![COOKEYS.dpt.rawValue] as! String,
                      COOKEYS.dpt_name.rawValue, self.submitValue![COOKEYS.dpt_name.rawValue] as! String,
                      COOKEYS.room.rawValue, self.submitValue![COOKEYS.room.rawValue] as! String,
                      COOKEYS.s_id.rawValue, self.submitValue![COOKEYS.s_id.rawValue] as! String,
                      COOKEYS.name.rawValue, self.submitValue![COOKEYS.name.rawValue] as! String,
                      COOKEYS.start_time.rawValue, self.submitValue![COOKEYS.start_time.rawValue] as! String,
                      COOKEYS.end_time.rawValue, self.submitValue![COOKEYS.end_time.rawValue] as! String,
                      COOKEYS.date.rawValue, self.submitValue![COOKEYS.date.rawValue] as! String
        )
    }
    
    func submitReservationInfoToServer(body: String){
        HttpHelper.Shared.Post(path: URLREQUEST.reservation_submit.rawValue,
                               paras: body,
                               success: {
                                (result: String) in
                                DispatchQueue.main.async {
                                    [weak self] in
                                    let cls: AnyClass? = MenuViewController.self
                                    for controller: UIViewController in (self?.navigationController?.viewControllers)!{
                                        if controller.isKind(of: cls!){
                                            self?.navigationController?.popToViewController(controller, animated: true)
                                        }
                                    }
                                }
        },
                               failure: { (err:String) in
                                print("submit error")
        })
    }
    @IBAction func onSubmitBtn(_ sender: UIButton){
        var alert: UIAlertController!
        alert = UIAlertController.init(title: "확인", message: "이 정보로 예약하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
        let submitAction = UIAlertAction.init(title: "확인", style: UIAlertActionStyle.default){
            (action:UIAlertAction) in
            let body = self.createSubmitBody()
            self.submitReservationInfoToServer(body: body)
        }
        let cancelAction = UIAlertAction.init(title: "취소", style: UIAlertActionStyle.destructive) { (action:UIAlertAction) in
            print("[+] SubmitReservationViewController : cancle")
        }
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() { 
        super.viewDidLoad()
        submitValue = delegate!.getCoockieValue()
        print("[+] viewDidLoad() : \(submitValue)")
        nameText = submitValue?[COOKEYS.name.rawValue] as! String
        dptText = submitValue?[COOKEYS.dpt.rawValue] as! String
        dpt_nameText = submitValue?[COOKEYS.dpt_name.rawValue] as! String
        s_idText = submitValue?[COOKEYS.s_id.rawValue] as! String
        roomText = submitValue?[COOKEYS.room.rawValue] as! String
        startTimeText = submitValue?[COOKEYS.start_time.rawValue] as! String
        endTimeText = submitValue?[COOKEYS.end_time.rawValue] as! String
        dateText = submitValue?[COOKEYS.date.rawValue] as! String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}
