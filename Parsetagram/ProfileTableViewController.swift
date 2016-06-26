//
//  ProfileTableViewController.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/22/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit
import Parse
import Foundation

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet weak var cogBarButton: UIBarButtonItem!
    
    var user: User?;
    var posts: [Post]?;
    
    var detailPost: Post?;
    
    var modal = false;
    var stallerView: UIView!;
    
    var readyForTableLayout = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var height = UIScreen.mainScreen().bounds.height;
        var width = UIScreen.mainScreen().bounds.width;
        let x = (width / 2) - (height / 8);
        let y = (height / 2) - (height / 8);
        height = height / 4;
        width = height;
        
        stallerView = UIView(frame: CGRect(x: x, y: y, width: width, height: height) );
        stallerView.layer.cornerRadius = 10;
        stallerView.backgroundColor = UIColor(white: 0, alpha: 0.75);
        stallerView.alpha = 0;
        let stallSpinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge);
        stallerView.addSubview(stallSpinner);
        stallSpinner.startAnimating();
        stallSpinner.bounds.origin = CGPoint(x: -height/2 + (stallSpinner.bounds.width/2), y: -height/2 + (stallSpinner.bounds.height/2));
        self.navigationController!.view.addSubview(self.stallerView);
        delay(0.25) { () -> () in
            UIView.animateWithDuration(0.25) { () -> Void in
                self.stallerView.alpha = 1;
            }
        }
        
        //fix length
        let logoImage = UIImage(named: "insta")!
        let imageView = UIImageView(image: logoImage);
        imageView.frame.size.height = (navigationController?.navigationBar.frame.size.height)! - 10;
        imageView.contentMode = .ScaleAspectFit;
        navigationItem.titleView = imageView;
        
        profileTableView.delegate = self;
        profileTableView.dataSource = self;
        
        profileTableView.rowHeight = UITableViewAutomaticDimension;
        profileTableView.estimatedRowHeight = 160.0;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        readyForTableLayout = true;
        
        if(user == nil) {
            if(User.currentUser() == nil) {
                readyForTableLayout = false;
                tableView.reloadData();
                return; // logged out
            }
            user = User.currentUser();
        }
        
        user!.posts(completion: { (posts: [PFObject]?, error: NSError?) -> Void in
            self.posts = posts as? [Post];
            self.tableView.reloadData();
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.stallerView.alpha = 0;
                }, completion: { (IdkWtfThisIs: Bool) -> Void in
                    self.stallerView.removeFromSuperview();
            })
        });
        
        if(modal) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(ProfileTableViewController.dismissModal));
        } else if(user!.objectId != User.currentUser()!.objectId) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil);
        } else {
            navigationItem.rightBarButtonItem?.enabled = true;
        }
        
    }
    
    func dismissModal() {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(readyForTableLayout) {
            let cellCount = Int(1.0 + ceil(Double(posts?.count ?? 0) / 3.0));
            return cellCount;
        }
        
        return 0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! ProfileHeaderTableViewCell;
            cell.user = user;
            cell.profileTableViewController = self;
            return cell;
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CollectionRowCell") as! ProfileCollectionRowTableViewCell;
            
            cell.profileTableController = self;
            
            var leftmostIndex = 3 * (indexPath.row - 1);
            
            cell.postOne = posts?[leftmostIndex++];
            
            if(leftmostIndex >= posts?.count) {
                cell.postTwo = nil;
                cell.postThree = nil;
                return cell;
            }
            
            cell.postTwo = posts?[leftmostIndex++];
            
            if(leftmostIndex >= posts?.count) {
                cell.postThree = nil;
                return cell;
            }
            
            cell.postThree = posts?[leftmostIndex++];
            return cell;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toDetails") {
            let dVc = segue.destinationViewController as! DetailsViewController;
            dVc.posts = [detailPost!];
        }
        
        
    }
    
}
