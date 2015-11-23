//
//  HomeNavController.swift
//  Eliminator
//
//  Created by Joshua Seger on 11/23/15.
//  Copyright © 2015 Creighton. All rights reserved.
//

import UIKit

class HomeNavController: UIViewController {

    var pageMenu : CAPSPageMenu?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: - UI Setup
        
        self.title = "Eliminator"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItemStyle.Done, target: self, action: "didTapGoToLeft")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItemStyle.Done, target: self, action: "didTapGoToRight")
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1 : HomeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        controller1.title = "Home"
        controllerArray.append(controller1)
        
        let controller2 : AddEventViewController = AddEventViewController(nibName: "AddEventViewController", bundle: nil)
        controller2.title = "Add Event"
        controllerArray.append(controller2)
        
        let controller3 : EventsTableViewController = EventsTableViewController(nibName: "EventsTableViewController", bundle: nil)
        controller3.title = "Upcoming Events"
        controllerArray.append(controller3)
        
        let controller4 : AddEventViewController = AddEventViewController(nibName: "AddEventViewController", bundle: nil)
        controller4.title = "Past Events"
        controllerArray.append(controller4)
        /*
        let controller2 : AddEventViewController = AddEventViewController()
        controller2.title = "Add Event"
        controllerArray.append(controller2)
        let controller3 : EventsTableViewController = EventsTableViewController()
        controller3.title = "Upcoming Events"
        controllerArray.append(controller3)
        let controller4 : PastEventsViewController = PastEventsViewController()
        controller4.title = "Past Events"
        controllerArray.append(controller4)
*/

        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .ViewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(colorWithHexString("#d580ff")),
            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 20.0)!),
            .MenuHeight(70.0),
            .MenuItemWidth(175.0),
            .CenterMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMoveToParentViewController(self)
    }
    
    func didTapGoToLeft() {
        var currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    func didTapGoToRight() {
        var currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }
    
    // MARK: - Container View Controller
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    
    // Creates a UIColor from a Hex string.
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}