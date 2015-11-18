//
//  FirstViewController.swift
//  Eliminator
//
//  Created by Joshua Seger on 11/2/15.
//  Copyright © 2015 Creighton. All rights reserved.
//

import UIKit
import Parse

class AddEventViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    @IBOutlet var EventDate: UIDatePicker!
    @IBOutlet var EventAttire: UIPickerView!
    @IBOutlet var EventSponsorParty: UITextField!
    @IBOutlet var EventLocation: UITextField!
    @IBOutlet var EventTitle: UITextField!
    var attireIndex = 0;
    @IBAction func CreateEvent(sender: AnyObject) {
        if !EventTitle.text!.isEmpty && !EventLocation.text!.isEmpty && !EventSponsorParty.text!.isEmpty {
            var event = PFObject(className: "FairEvent")
            event["Title"] = EventTitle.text
            event["Location"] = EventLocation.text
            event["SponsoringParty"] = EventSponsorParty.text
            event["Attire"] = attireData[attireIndex];
            event["Date"] = EventDate.date
            event.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.displayAlertWithTitle("Event successfully saved!", message: "GREAT SUCCESS")
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
        }
    }
    @IBOutlet var CreateEventButton: UIButton!
    @IBOutlet var FormBackground: UIView!
    @IBOutlet var AttirePicker: UIPickerView!
    let attireData = ["Formal", "Semi-Formal", "Casual"]
    override func viewDidLoad() {
        CreateEventButton.layer.cornerRadius = 20.0
        FormBackground.backgroundColor = UIColor.lightGrayColor()
        FormBackground.layer.cornerRadius = 10.0
        FormBackground.layer.borderColor = UIColor.grayColor().CGColor
        FormBackground.layer.borderWidth = 0.5
        self.view.backgroundColor = UIColor.blackColor()
        AttirePicker.dataSource = self
        AttirePicker.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return attireData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return attireData[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        attireIndex = row;
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
}
