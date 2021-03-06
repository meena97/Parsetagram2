//
//  CommentCell.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/22/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit
import Parse

class CommentCell: UITableViewCell {
    
    weak var commentsTableController: CommentsTableViewController?;
    
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var loadingProfile = false;
    
    var comment: PFObject? {
        didSet {
            let user = comment!["user"] as? User;
            
            profilePicView.setImageWithURL(user!.profilePicURL!);
            usernameLabel.text = user!.username;
            contentLabel.text = comment!["content"] as? String;
            ageLabel.text = Post.timeSince(comment!.createdAt!);
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(CommentCell.openProfile));
        usernameLabel.userInteractionEnabled = true;
        usernameLabel.addGestureRecognizer(tapGestureRecognizer);
        
        profilePicView.clipsToBounds = true;
        profilePicView.layer.cornerRadius = 15;
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func openProfile() {
        if(loadingProfile) {
            return;
        }
        loadingProfile = true;
        delay(1.0) { () -> () in
            self.loadingProfile = false;
        }
        
        
        UIView.animateWithDuration(0.05) { () -> Void in
            self.usernameLabel.alpha = 0.25;
            self.profilePicView.alpha = 0.25;
        }
        delay(0.2) { () -> () in
            UIView.animateWithDuration(0.2) { () -> Void in
                self.usernameLabel.alpha = 1;
                self.profilePicView.alpha = 1;
            }
            
            let vc = storyboard.instantiateViewControllerWithIdentifier("ProfileTableViewController") as! ProfileTableViewController;
            vc.user = User.getUserByUsername(self.usernameLabel.text!);
            self.commentsTableController?.navigationController?.pushViewController(vc, animated: true);
        }
    }
}
