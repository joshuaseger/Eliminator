//
//  EventsViewController.swift
//  Eliminator
//
//  Created by Joshua Seger on 11/2/15.
//  Copyright © 2015 Creighton. All rights reserved.
//

import UIKit
import Parse

class EventsTableViewController: UITableViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    let user = PFUser.currentUser()
    var events = [PFObject]()
    var rowCount: Int = 0
    
    override func viewDidLoad() {
        
        self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        super.viewDidLoad()
        
        let relation = user?.relationforKey("UpcomingEventList")

        relation?.query()!.findObjectsInBackgroundWithBlock {
            (Events: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.events = [PFObject]()
                for event in Events!{
                    print(event)
                    self.events.append(event as PFObject)
                }
            }else {
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.rowCount = self.events.count
            self.tableView.registerNib(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "cell")
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {


    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? EventCell
        if ( cell == nil){
            cell = EventCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell") as EventCell!
        }
        print(indexPath.row)
        print(self.events.count)
        let event = self.events[indexPath.row] as PFObject
        print(event["Title"] as? String);
        cell?.TitleLabel.text = event["Title"] as? String;
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let date = dateFormatter.stringFromDate((event["Date"] as? NSDate)!)
        cell?.DateLabel.text = date;
        
        
        return cell!
        
    }
    

    var valueToPass:String!;
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow;
        let event = events[(indexPath?.row)!];
        var eventId = event.objectId;
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewControllerWithIdentifier("CandidateNavController") as! CandidateNavController
        newViewController.eventId = eventId;
        
        
        self.navigationController?.pushViewController(newViewController, animated: true)
        
       


        
        
    }
    

    
    
}
