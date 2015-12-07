//
//  CandidateFormViewController.swift
//  Eliminator
//
//  Created by Joshua Seger on 12/6/15.
//  Copyright © 2015 Creighton. All rights reserved.
//

import UIKit
import Parse

class CandidateFormViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var jobInterestToggle: UISwitch!
    var jobInterestArray : [Bool] = []
    @IBOutlet weak var resumeLabel: UILabel!
    @IBOutlet weak var headshotLabel: UILabel!
    @IBOutlet weak var resumePreview: UIImageView!
    @IBOutlet weak var headshotPreview: UIImageView!
    @IBOutlet weak var jobPostingPicker: UIPickerView!
    var jobPostList : [PFObject] = []
    var selectedJobPosting = PFObject(className: "JobPosting")
    var user = PFUser.currentUser()
    var event : PFObject!;
    var resumePicker: UIImagePickerController!
    var headshotPicker: UIImagePickerController!
    var postingCurrentIndex = 0
    
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var universityLabel: UITextField!
    @IBOutlet weak var gpaLabel: UITextField!
    @IBOutlet weak var majorLabel: UITextField!
    @IBOutlet weak var graduationDatePicker: UIDatePicker!
    @IBOutlet weak var interestIndicatorImage: UIImageView!
    
    
    
    @IBAction func toggleJobInterest(sender: AnyObject) {
        self.jobInterestArray[self.postingCurrentIndex] = self.jobInterestToggle.on
        if(self.jobInterestToggle.on){
            self.interestIndicatorImage.image = UIImage(named: "checkYes.png")
        }
        else{
            self.interestIndicatorImage.image = UIImage(named: "xMark.png")
        }
    }
    @IBAction func takeResume(sender: AnyObject) {
        resumePicker =  UIImagePickerController()
        resumePicker.delegate = self;
        resumePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        resumePicker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        presentViewController(resumePicker, animated: true, completion: nil)
    }
    @IBAction func takeHeadshot(sender: AnyObject) {
        headshotPicker =  UIImagePickerController()
        headshotPicker.delegate = self;
        headshotPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        headshotPicker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        presentViewController(headshotPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if(picker == self.resumePicker){
            resumePicker.dismissViewControllerAnimated(true, completion: nil)
            resumePreview.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            resumeLabel.hidden = true
        }
        else{
            headshotPicker.dismissViewControllerAnimated(true, completion: nil)
            headshotPreview.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            headshotLabel.hidden = true
            
        }
       
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return jobPostList.count
    }
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        var post = jobPostList[row]
        var postingTitle = post["Title"] as! String
        var postingCity = post["City"] as! String
        var postingState = post["State"] as! String
        var postTitle = "\(postingTitle) in \(postingCity), \(postingState)"
        let attributedString = NSAttributedString(string: postTitle, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedJobPosting = self.jobPostList[row]
        self.postingCurrentIndex = row;
        var interestedInJob = self.jobInterestArray[row]
        self.jobInterestToggle.setOn(interestedInJob, animated: true)
        if(interestedInJob){
          self.interestIndicatorImage.image = UIImage(named: "checkYes.png")
        }
        else{
            self.interestIndicatorImage.image = UIImage(named: "xMark.png")
        }
        
        
    }
    
    @IBAction func createCandidate(sender: AnyObject) {
    }
    
    override func viewWillAppear(animated: Bool) {
        let relation = event?.relationforKey("JobPostList")
        relation?.query()!.findObjectsInBackgroundWithBlock {
            (postings: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.jobPostList = [PFObject]()
                for post in postings!{
                    print(post)
                    self.jobPostList.append(post as PFObject)
                }
                self.jobInterestArray = Array(count:self.jobPostList.count, repeatedValue: false)
                self.jobPostingPicker.reloadAllComponents()
            }else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        graduationDatePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        graduationDatePicker.performSelector("setHighlightsToday:", withObject:UIColor.whiteColor())

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
