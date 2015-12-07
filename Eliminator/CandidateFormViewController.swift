//
//  CandidateFormViewController.swift
//  Eliminator
//
//  Created by Joshua Seger on 12/6/15.
//  Copyright © 2015 Creighton. All rights reserved.
//

import UIKit

class CandidateFormViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var resumePreview: UIImageView!
    @IBOutlet weak var headshotPreview: UIImageView!
    
    @IBAction func takeResume(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func takeHeadshot(sender: AnyObject) {
    }
    
    var imagePicker: UIImagePickerController!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        resumePreview.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
