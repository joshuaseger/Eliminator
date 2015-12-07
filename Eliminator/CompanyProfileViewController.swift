//
//  CompanyProfileViewController.swift
//  Eliminator
//
//  Created by Joshua Seger on 11/27/15.
//  Copyright © 2015 Creighton. All rights reserved.
//

import UIKit
import Parse


class CompanyProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBAction func submitButton(sender: AnyObject) {
        
    }

    @IBAction func createJobPosting(sender: AnyObject) {
        var jobPosting = PFObject(className: "JobPosting")
        jobPosting["Title"] = jobTitle.text
        jobPosting["City"] = jobCity.text
        jobPosting["State"] = selectedState
        
        jobPosting.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if(success){
                var relation = self.user?.relationforKey("JobPostingList")
                relation?.addObject(jobPosting)
                self.user?.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                        if(success){
                            self.displayAlertWithTitle("Job Posting successfully saved!", message: "GREAT SUCCESS")
                        }
                        else{
                            self.displayAlertWithTitle("Job Posting did not save", message: "Failed to create relation for key Upcoming Job Posting List")
                        }
                    }
            }
            else{
                self.displayAlertWithTitle("Job Posting did not save", message: "Failed to save Job Posting.  Check your connection.")
            }
            
        }
    }
    let user = PFUser.currentUser()
    var selectedState = ""
    @IBOutlet weak var jobPostingPicker: UIPickerView!
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var jobCity: UITextField!
    @IBOutlet weak var jobState: UIPickerView!
    @IBOutlet var companyName: UITextField!
    @IBOutlet var companySize: UITextField!
    @IBOutlet var hqCity: UITextField!
    @IBOutlet var hqState: UITextField!
    @IBOutlet var yearFound: UITextField!
    @IBOutlet weak var companyDescription: UITextView!

    let states = ["AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY", "AE", "AA", "AP"]
    var jobPostingList: [PFObject] = []
    var selectedJobPosting = PFObject(className: "JobPosting")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobPostingPicker.dataSource = self
        jobPostingPicker.delegate = self
        jobState.dataSource = self
        jobState.delegate = self
        jobState.tag = 1
        jobPostingPicker.tag = 0
        companyDescription.layer.cornerRadius =  10.0;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let relation = user?.relationforKey("JobPostingList")
        relation?.query()!.findObjectsInBackgroundWithBlock {
            (postings: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.jobPostingList = [PFObject]()
                for post in postings!{
                    print(post)
                    self.jobPostingList.append(post as PFObject)
                }
                self.jobPostingPicker.reloadAllComponents()
            }else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return states.count
        }
        else{
            return self.jobPostingList.count
        }
    }

    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if(pickerView.tag == 1){
            let attributedString = NSAttributedString(string: states[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            return attributedString
        }
        else{
            var post = jobPostingList[row]
            var postingTitle = post["Title"] as! String
            var postingCity = post["City"] as! String
            var postingState = post["State"] as! String
            var postTitle = "\(postingTitle) in \(postingCity), \(postingState)"
            let attributedString = NSAttributedString(string: postTitle, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            return attributedString

        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            self.selectedState = states[row]
        }
        else{
            self.selectedJobPosting = jobPostingList[row]
        }
        
    }
    


    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
