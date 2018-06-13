//
//  TimeViewController.swift
//  TeamProject
//
//  Created by apple11 on 2018. 6. 5..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController, ValueTransDelegate {
    var delegate: ValueTransDelegate?
    let dateformatter = DateFormatter()
    func getCoockieValue() -> [String : AnyObject] {
        var value = delegate?.getCoockieValue()
        value!["S_TIME"] = startTime! as AnyObject
        value!["F_TIME"] = endTime! as AnyObject
        return value!
    }
    var endTime : String?{
        didSet{
            EndTimeView.setTitle(endTime!, for: .normal)
            if let start = startTime, let end = endTime{
                dateformatter.dateFormat = "HH:mm:00"
                dateformatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale!
                let date1 = dateformatter.date(from: start)
                var dateNSVersion = date1 as! NSDate
                let date2 = dateformatter.date(from:end)
                if((date1?.compare(date2!) == .orderedDescending) || (date1?.compare(date2!) == .orderedSame)){
                    if(self.Submit.isEnabled != false){
                        self.Submit.isEnabled = false
                    }
                }else if self.Submit.isEnabled == false{
                    self.Submit.isEnabled = true
                }
            }
        }
    }
    var startTime : String?{
        didSet{
            StartTimeView.setTitle(startTime!, for: .normal)
            if let start = startTime, let end = endTime{
                dateformatter.dateFormat = "HH:mm:00"
                dateformatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale!
                let date1 = dateformatter.date(from: start)
                var dateNSVersion = date1 as! NSDate
                let date2 = dateformatter.date(from:end)
                if date1?.compare(date2!) == .orderedDescending{
                    if(self.Submit.isEnabled != false){
                        self.Submit.isEnabled = false
                    }
                }else if self.Submit.isEnabled == false{
                    self.Submit.isEnabled = true
                }
            }
        }
    }
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var StartTimeView: UIButton!
    @IBOutlet weak var EndTimeView: UIButton!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var Submit: UIButton!{
        didSet{
            Submit.isEnabled = false
        }
    }
    @IBAction func StartTimeBtn(_ sender: UIButton){
        StartTimeViewIsSelected = true;
        print("start")
    }
    
    @IBAction func EndTimeBtn(_ sender: UIButton){
        StartTimeViewIsSelected = false;
        print("end")
    }
    
    var StartTimeViewIsSelected : Bool = true;
    
    
    @objc func timePickerIsChanged(picker:UIDatePicker) {
        
        if(StartTimeViewIsSelected){
            let timeFormatter : DateFormatter = DateFormatter();
            timeFormatter.dateFormat = "HH:mm:00"
            startTime = timeFormatter.string(from: picker.date)
            
        }else{
            let timeFormatter : DateFormatter = DateFormatter();
            timeFormatter.dateFormat = "HH:mm:00"
            endTime = timeFormatter.string(from: picker.date)
        }
    }
    
    @objc func timeEndViewSelected(gesture : UITapGestureRecognizer){
        
        StartTimeView.backgroundColor = UIColor.white;
        EndTimeView.backgroundColor = UIColor.white;
        StartTimeViewIsSelected = false;
        StartTimeView.isUserInteractionEnabled = false;
        EndTimeView.isUserInteractionEnabled = true;
        print("end")
    }
    @objc func timeStartViewSelected(gesture : UITapGestureRecognizer){
        
        EndTimeView.backgroundColor = UIColor.white;
        StartTimeView.backgroundColor = UIColor.white;
        StartTimeViewIsSelected = true;
        EndTimeView.isUserInteractionEnabled = false;
        StartTimeView.isUserInteractionEnabled = true;
        print("start")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartTimeView.changeBorder()
        EndTimeView.changeBorder()
        timePicker.addTarget(self, action: #selector(timePickerIsChanged(picker:)), for: .valueChanged);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! SubmitReservationViewController
        controller.delegate = self

        
    }

}
extension UIButton{
    func changeBorder(){
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10
    }
}
