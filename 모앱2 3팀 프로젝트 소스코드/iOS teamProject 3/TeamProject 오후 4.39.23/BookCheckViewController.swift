//
//  BookCheckViewController.swift
//  TeamProject
//
//  Created by 권용진 on 2018. 6. 5..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit

class BookCheckViewController: UIViewController {
    var images = ["classroom.jpg", "libary.jpg"]
    @IBOutlet weak var cardView: UIView!{
        didSet{
            self.cardView.changeLayer()
        }
    }
    @IBOutlet weak var reservationInfoCurLabel: UILabel!{
        didSet{
            reservationInfoCurLabel.text = "0/0"
        }
    }
    @IBOutlet weak var backCardView: UIView!{
        didSet{
            self.backCardView.changeLayer()
        }
    }
    @IBOutlet weak var secondBackCardView: UIView!{
        didSet{
            self.secondBackCardView.changeLayer()
        }
    }
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var rocateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var sidLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            self.cancelButton.changeBorder()
            cancelButton.setTitleColor(UIColor.blue, for: .normal)
            cancelButton.setTitleColor(UIColor.gray, for: .disabled)
        }
    }
    func changeReservationInfoCurLabel(){
        reservationInfoCurLabel.text = "\(reservation_index+1)/\(reservationCount)"
    }
    var reservationCount: Int = 0{
        didSet{
            changeReservationInfoCurLabel()
        }
    }
    var reservation_index : Int = -1{
        didSet{
            if reservation_index < 0 {
                reservation_index = reservationInfo.count - 1
            }else if reservation_index > reservationInfo.count - 1{
                reservation_index = 0
            }
            changeReservationInfoCurLabel()
            changeReservationCard()
        }
    }
    @IBAction func cancelB(_ sender: UIButton) {
        var alert: UIAlertController!
        alert = UIAlertController.init(title: "확인", message: "예약 정보를 취소하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
        let submitAction = UIAlertAction.init(title: "확인", style: UIAlertActionStyle.default){
            (action:UIAlertAction) in
            let body = String(format: "%@=%@",
                              COOKEYS.reservation_no.rawValue, self.numberLabel.text as! String
            )
            self.cancelReservationPost(body:body)
        }
        let cancelAction = UIAlertAction.init(title: "취소", style: UIAlertActionStyle.destructive) { (action:UIAlertAction) in
            print("[+] BookCheckViewController : cancel")
        }
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getReservationInfo(){
        let body = "NAME=\(userInfo[COOKEYS.name.rawValue] as! String)&S_ID=\(userInfo[COOKEYS.s_id.rawValue] as! String)"
        HttpHelper.Shared.Post(path: URLREQUEST.reservation_check.rawValue,
                               paras: body,
                               success: {
                                (result : String) in
                                let data = result.data(using:.utf8)!
                                do{
                                    if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Dictionary<String, Any>]{
                                        self.reservationInfo = json as [[String : AnyObject]]
                                        DispatchQueue.main.async {
                                            self.reservation_index = 0
                                            if(self.reservationInfo.isEmpty){
                                                self.reservationCount = 0
                                                self.cancelButton.isEnabled = false
                                            }else{
                                                self.addGestureRecognizer()
                                                self.reservationCount = self.reservationInfo.count
                                                self.cancelButton.isEnabled = true
                                            }
                                        }
                                    }else{
                                        self.reservationCount = 0
                                        print("error!")
                                    }
                                }catch let err as NSError{
                                    self.reservationCount = 0
                                    print(err)
                                }
                                print(result)
        }, failure: {
            (error: String) in
            print("")
        })
    }
    func cancelReservationPost(body: String){
        HttpHelper.Shared.Post(path: URLREQUEST.reservation_cancel.rawValue,
                               paras: body,
                               success: {
                                (result: String) in
                                DispatchQueue.main.async {
                                    [weak self] in
                                    print("no cancel error")
                                    
                                    let cls: AnyClass? = MenuViewController.self
                                    for controller: UIViewController in (self?.navigationController?.viewControllers)!{
                                        if controller.isKind(of: cls!){                                            self?.navigationController?.popToViewController(controller, animated: true)
                                        }
                                    }
                                }
        },
                               failure: { (err:String) in
                                DispatchQueue.main.async {
                                    print("ccancel error")
                                };print("cancel error!")
        })
    }
    func changeReservationCard(){
        self.imgView.image = UIImage(named: images[reservation_index%2])
        self.numberLabel.text = String(self.reservationInfo[reservation_index][COOKEYS.reservation_no.rawValue] as! Int)
        self.userLabel.text = self.reservationInfo[reservation_index][COOKEYS.name.rawValue] as! String
        self.sidLabel.text = self.reservationInfo[reservation_index][COOKEYS.s_id.rawValue] as! String
        self.rocateLabel.text = String(format:"%@ %@ %@",(reservationInfo[reservation_index][COOKEYS.dpt.rawValue] as? String)!,(reservationInfo[reservation_index][COOKEYS.dpt_name.rawValue] as? String)!,((reservationInfo)[reservation_index][COOKEYS.room.rawValue] as? String!)!)
        self.dateLabel.text = (self.reservationInfo[reservation_index][COOKEYS.date.rawValue] as! String)[0..<10]
        self.timeLabel.text = String(format:"%@ - %@",(reservationInfo[reservation_index][COOKEYS.start_time.rawValue] as? String)!,(reservationInfo[reservation_index][COOKEYS.end_time.rawValue] as? String)!)
        if let mystate = reservationInfo[reservation_index][COOKEYS.reservation_state.rawValue] as? Int{
            switch mystate{
            case state.denied.rawValue:
                self.confirmLabel.text = "예약 거부"
                break
            case state.permission.rawValue:
                self.confirmLabel.text = "예약 완료"
                break
            case state.reservating.rawValue:
                self.confirmLabel.text = "예약 대기"
                break
            default:
                self.confirmLabel.text = "error"
                break
            }
        }
    }
    var delegate: ValueTransDelegate?
    var userInfo: [String: AnyObject] = [:]
    var reservationInfo: [[String: AnyObject]] = []
    override func viewDidLoad() {
        self.navigationItem.title = "예약확인";
        super.viewDidLoad()
        self.cancelButton.isEnabled = false
        userInfo = (delegate?.getCoockieValue())!
        getReservationInfo()
    }
    func addGestureRecognizer(){
        let swipLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(swip:)))
        swipLeft.direction = .left
        let swipRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(swip:)))
        swipRight.direction = .right
        self.view.addGestureRecognizer(swipLeft)
        self.view.addGestureRecognizer(swipRight)
    }
    @objc func swipeGesture(swip: UISwipeGestureRecognizer){
        if swip.direction == .left{
            print("left")
            self.reservation_index -= 1
        }else if swip.direction == .right{
            print("right")
            self.reservation_index += 1
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
extension UIView {
    func changeLayer(){
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 10.0
    }
}
