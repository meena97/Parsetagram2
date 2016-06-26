//
//  CommentEditorTableViewCell.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/22/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit

class CommentEditorTableViewCell: UITableViewCell {
    
    weak var commentTableViewController: CommentsTableViewController?;
    
    var post: Post?;
    
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var sendButtonSuperview: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sendButtonSuperview.layer.cornerRadius = 5;
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func editingDidChange(sender: AnyObject) {
        if(commentField.text?.characters.count > 0) {
            sendButton.alpha = 1;
        } else {
            sendButton.alpha = 0.5;
        }
    }
    
    @IBAction func onSendButton(sender: AnyObject) {
        commentField.resignFirstResponder();
        let commentText = commentField.text!;
        if(commentField.text!.characters.count > 0){
            sendButton.hidden = true;
            activityIndicator.startAnimating();
            commentField.userInteractionEnabled = false;
            commentField.textColor = UIColor.lightGrayColor();
            self.activityIndicator.alpha = 1;
            
            post!.comment(commentText) { (success: Bool, error: NSError?) -> Void in
                Post.postCache[self.post!.objectId!] = nil;
                self.commentTableViewController!.reloadComments(true);
                self.activityIndicator.stopAnimating();
                self.sendButton.hidden = false;
                self.commentField.text = "";
                self.commentField.userInteractionEnabled = true;
                self.commentField.textColor = UIColor.blackColor();
                self.activityIndicator.alpha = 0;
            }
        }
    }
}
