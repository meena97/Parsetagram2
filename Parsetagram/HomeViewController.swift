//
//  HomeViewController.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/22/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post]?;
    
    var inspectPostComments: Post?;
    
    var moreData = false;
    
    var refreshControl: UIRefreshControl!;
    var loadingImages: InfiniteScrollActivityView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 160.0;
        
        let logoImage = UIImage(named: "insta")!
        let imageView = UIImageView(image: logoImage);
        imageView.frame.size.height = (navigationController?.navigationBar.frame.size.height)! - 10;
        //imageView.frame.size.width = (navigationController?.navigationBar.frame.size.width)!;
        imageView.contentMode = .ScaleAspectFit;
        navigationItem.titleView = imageView;
        
        //Infinite scrolling
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
        loadingImages = InfiniteScrollActivityView(frame: frame);
        loadingImages!.hidden = true;
        tableView.addSubview(loadingImages!);
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: #selector(HomeViewController.onRefresh), forControlEvents: UIControlEvents.ValueChanged);
        tableView.insertSubview(refreshControl, atIndex: 0);
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        if((posts == nil) && (User.currentUser() != nil)) {
            reloadTable();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable(append: Bool = false) {
        
        var completion: PFQueryArrayResultBlock = { (posts: [PFObject]?, error: NSError?) -> Void in
            self.posts = posts as? [Post];
            self.moreData = false
            self.loadingImages!.stopAnimating()
            self.tableView.reloadData();
        }
        
        if(append) {
            completion = { (posts: [PFObject]?, error: NSError?) -> Void in
                
                for post in posts! {
                    self.posts?.append(post as! Post);
                }
                
                self.moreData = false
                self.loadingImages!.stopAnimating()
                
                if(posts?.count > 0) {
                    self.tableView.reloadData();
                }
            }
        }
        
        var offset = 0;
        if((append == true) && (posts != nil)) {
            offset = posts!.count;
        }
        
        Post.fetchPosts(offset, completion: completion);
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return posts?.count ?? 0;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell;
        cell.post = posts![indexPath.section];
        cell.tableViewController1 = self;
        cell.indexPathSection = indexPath.section;
        
        if(posts!.count - 1 >= indexPath.section + 1){
            posts![indexPath.section + 1].buffer();
        }
        if(posts!.count - 1 >= indexPath.section + 2){
            posts![indexPath.section + 2].buffer();
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 50));
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.97);
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30));
        profileView.clipsToBounds = true;
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        let ageView = UILabel(frame: CGRect(x: UIScreen.mainScreen().bounds.width - 60, y: 11, width: 50, height: 30));
        ageView.textAlignment = NSTextAlignment.Right;
        ageView.font = UIFont.systemFontOfSize(12.0);
        ageView.textColor = UIColor(white: 0.75, alpha: 1.0);
        
        let usernameView = UILabel(frame: CGRect(x: 50, y: 10, width: 150, height: 30));
        usernameView.textAlignment = NSTextAlignment.Left;
        usernameView.font = UIFont.systemFontOfSize(14.0, weight: UIFontWeightMedium);
        usernameView.textColor = UIColor(red: 0.247, green: 0.4471, blue: 0.608, alpha: 1.0);
        
        if let posts = posts {
            profileView.setImageWithURL(
                posts[section].author!.profilePicURL!
            );
            
            usernameView.text = posts[section].author?.username;
            ageView.text = Post.timeSince(posts[section].createdAt!);
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.onTappedUsername(_:)));
        tap.delegate = self;
        usernameView.userInteractionEnabled = true;
        usernameView.addGestureRecognizer(tap);
        
        headerView.addSubview(profileView);
        headerView.addSubview(ageView);
        headerView.addSubview(usernameView);
        return headerView;
    }
    
    
    
    func onTappedUsername(sender: UITapGestureRecognizer) {
        let authorUsernameLabel = sender.view as! UILabel;
        authorUsernameLabel.textColor = UIColor.lightGrayColor();
        
        let pVc = storyboard!.instantiateViewControllerWithIdentifier("ProfileTableViewController") as! ProfileTableViewController;
        pVc.user = User.getUserByUsername(authorUsernameLabel.text!);
        navigationController?.pushViewController(pVc, animated: true);
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
    func onRefresh() {
        reloadTable();
        delay(2, closure: {
            self.refreshControl.endRefreshing();
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(posts?.count < 5) {
            return;
        }
        
        if (!moreData) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                moreData = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingImages?.frame = frame
                loadingImages!.startAnimating()
                
                delay(1.0, closure: { () -> () in
                    self.reloadTable(true);
                });
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toComments") {
            let vc = segue.destinationViewController as! CommentsTableViewController;
            vc.post = inspectPostComments;
            vc.parentCell = sender as! PostCell;
        }
    }
}
