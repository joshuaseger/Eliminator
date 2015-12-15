//
//  FirstViewController.swift
//  Eliminator
//
//  Created by Joshua Seger, Justin Peck on 11/2/15.
//  Copyright © 2015 Creighton. All rights reserved.
//

import UIKit
import Parse

class AddEventViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    let user = PFUser.currentUser()
    @IBOutlet var EventDate: UIDatePicker!
    @IBOutlet var EventSponsorParty: UITextField!
    @IBOutlet var EventLocation: UITextField!
    @IBOutlet var EventTitle: UITextField!
    var attireIndex = 0;
    var jobPostings : [PFObject] = []

        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    @IBAction func CreateEvent(sender: AnyObject) {
        if !EventTitle.text!.isEmpty && !EventLocation.text!.isEmpty && !EventSponsorParty.text!.isEmpty {
            let event = PFObject(className: "UpcomingEvent")
            event["Title"] = EventTitle.text
            event["Location"] = EventLocation.text
            event["SponsoringParty"] = EventSponsorParty.text
            event["Attire"] = attireData[attireIndex];
            event["Date"] = EventDate.date
            
            let jobPostRelation = event.relationForKey("JobPostList")
            for post in self.jobPostings{
                post.saveInBackground()
                 jobPostRelation.addObject(post)
            }
            event.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    let relation = self.user!.relationForKey("UpcomingEventList")
                    relation.addObject(event)
                    self.user?.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if(success){
                            
                            self.displayAlertWithTitle("Event successfully saved!", message: "GREAT SUCCESS")
                        }
                        else{
                            self.displayAlertWithTitle("Event did not save", message: "Failed to create relation for key Upcoming Event List")
                        }
                    }
                    
                    // The object has been saved.
                } else {
                    self.displayAlertWithTitle("Event did not save", message: "Failed to save event object. Check your connection!")

                    // There was a problem, check error.description
                }
            }
        }
    }
    
    @IBOutlet var AttirePicker: UIPickerView!
    let attireData = ["Formal", "Semi-Formal", "Casual"]
    
    
    override func viewDidLoad() {
        EventDate.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        EventDate.performSelector("setHighlightsToday:", withObject:UIColor.whiteColor())
        AttirePicker.dataSource = self
        AttirePicker.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {

        let relation = self.user!.relationForKey("JobPostingList")
        relation.query()!.findObjectsInBackgroundWithBlock {
            (posts: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.jobPostings = [PFObject]()
                for post in posts!{
                    print(post)
                    self.jobPostings.append(post as PFObject)
                }
                if(posts?.count == 0){
                    self.displayAlertWithTitle("No Jobs Posted yet", message: "Go to your company profile to create a job posting that will be automatically tied to any events you create")
                }
            }else {
                self.displayAlertWithTitle("Failed to load job posts", message: "Check your network connectivity")
            }
        }
        
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
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: attireData[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
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
