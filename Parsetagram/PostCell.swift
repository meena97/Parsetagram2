//
//  PostCell.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/22/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit
import Parse

class PostCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var heartIcon: UIImageView!
    
    @IBOutlet weak var heartIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heartIconHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var favoriteButton: DOFavoriteButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    
    @IBOutlet weak var commentsLabelHeightConstraint: NSLayoutConstraint!
    
    
    var useTableView2 = false;
    weak var tableViewController1: HomeViewController? {
        didSet {
            useTableView2 = false;
        }
    }
    weak var tableViewController2: DetailsViewController? {
        didSet {
            useTableView2 = true;
        }
    }
    
    var indexPathSection: Int?;
    
    var loadingComments = false;
    
    func generateAttributedComment(username: String, content: String, footer: String = "") -> NSMutableAttributedString {
        let root = NSMutableAttributedString();
        
        let handle = NSMutableAttributedString(string: username);
        handle.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14.0, weight: UIFontWeightMedium), range: NSRange(location: 0, length: username.characters.count));
        handle.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 12/255.0, green: 93/255.0, blue: 168/255.0, alpha: 1), range: NSRange(location: 0, length: username.characters.count));
        root.appendAttributedString(handle);
        
        let caption = NSMutableAttributedString(string: "  " + content + footer);
        caption.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14.0, weight: UIFontWeightRegular), range: NSRange(location: 0, length: content.characters.count + 2));
        caption.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: content.characters.count + 2));
        root.appendAttributedString(caption);
        
        return root;
    }
    
    var post: Post? {
        didSet {
            configureSubviews(post?.getCachedComments({ (comments: [PFObject]?) -> () in
                self.configureSubviews(comments);
            }));
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        let tapGestureRecognizerA = UITapGestureRecognizer(target: self, action: #selector(PostCell.onLikeButton(_:)));
        favoriteButton.addGestureRecognizer(tapGestureRecognizerA);
        let holdGestureRecognizerA = UILongPressGestureRecognizer(target:self, action:Selector("openLikes"));
        holdGestureRecognizerA.minimumPressDuration = 0.25;
        favoriteButton.addGestureRecognizer(holdGestureRecognizerA);
        tapGestureRecognizerA.requireGestureRecognizerToFail(holdGestureRecognizerA);
        
        
        let tapGestureRecognizer1 = UILongPressGestureRecognizer(target:self, action:#selector(PostCell.openComments));
        tapGestureRecognizer1.minimumPressDuration = 0.001;
        commentsCount.addGestureRecognizer(tapGestureRecognizer1);
        
        let tapGestureRecognizer2 = UILongPressGestureRecognizer(target:self, action:#selector(PostCell.openComments));
        tapGestureRecognizer2.minimumPressDuration = 0.001;
        commentsLabel.addGestureRecognizer(tapGestureRecognizer2);
        
        let tapGestureRecognizer3 = UILongPressGestureRecognizer(target:self, action:#selector(PostCell.openComments));
        tapGestureRecognizer3.minimumPressDuration = 0.001;
        captionLabel.addGestureRecognizer(tapGestureRecognizer3);
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target:self, action:#selector(PostCell.openPreview));
        longPressGestureRecognizer.minimumPressDuration = 0.25;
        postImageView.userInteractionEnabled = true;
        postImageView.addGestureRecognizer(longPressGestureRecognizer);
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureSubviews(commentsThread: [PFObject]?) {
        var comments = commentsThread;
        
        var style = NSMutableParagraphStyle();
        
        if(post!.caption != "" && comments!.count > 0) {
            comments!.removeAtIndex(0);
            let attributedCaption = generateAttributedComment(post!.author!.username!, content: post!.caption!);
            style.lineSpacing = 0;
            style.lineBreakMode = .ByWordWrapping;
            attributedCaption.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: attributedCaption.string.characters.count));
            captionLabel.attributedText = attributedCaption;
        }
        
        let root = NSMutableAttributedString();
        
        if(comments?.count <= 0) {
            commentsLabelHeightConstraint.constant = 0;
        } else {
            for (index, comment) in comments!.enumerate() {
                let commentAuthor = comment["user"] as! User;
                root.appendAttributedString(generateAttributedComment(commentAuthor.username!, content: (comment["content"] as! String), footer: (index == comments!.count - 1 ? "" : "\n")));
            }
        }
        style = NSMutableParagraphStyle();
        style.lineSpacing = 0;
        style.lineBreakMode = .ByWordWrapping;
        root.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: root.string.characters.count));
        commentsLabel.attributedText = root;
        
        postImageView.setImageWithURL(post!.mediaURL!);
        
        favoriteButton.selected = post!.liked;
        
        setLikesLabel(Post.shortenNumber(Double((post?.getCachedLikesCount({ (count: Int?) -> () in
            self.setLikesLabel(Post.shortenNumber(Double(count!)));
        }))!)));
        
        
        setCommentsCountLabel(Post.shortenNumber(Double((post?.getCachedCommentsCount({ (count: Int?) -> () in
            self.setCommentsCountLabel(Post.shortenNumber(Double(count!) - (self.post!.caption == "" ? 0.0 : 1.0)));
        }))!) - (post!.caption == "" ? 0.0 : 1.0)));
        
    }
    
    func setCommentsCountLabel(commentCountOverrideValue: String? = nil) {
        var comments = commentCountOverrideValue;
        if(comments == nil && post != nil) {
            comments = Post.shortenNumber(Double(post!.commentsCount!) - (post!.caption == "" ? 0.0 : 1.0));
        }
        commentsCount.text = (comments! == "0" ? "" : comments);
    }
    
    func setLikesLabel(likeCountOverrideValue: String? = nil) {
        var likes = likeCountOverrideValue;
        if(likes == nil && post != nil) {
            likes = Post.shortenNumber(Double(post!.likesCount!));
        }
        likesCount.text = (likes! == "0" ? "" : likes);
    }
    
    func openComments() {
        if(loadingComments) {
            return;
        }
        loadingComments = true;
        delay(1.0) { () -> () in
            self.loadingComments = false;
        }
        
        
        UIView.animateWithDuration(0.05) { () -> Void in
            self.commentsCount.alpha = 0.25;
            self.captionLabel.alpha = 0.25;
            self.commentsLabel.alpha = 0.25;
        }
        delay(0.2) { () -> () in
            UIView.animateWithDuration(0.2) { () -> Void in
                self.commentsCount.alpha = 1;
                self.captionLabel.alpha = 1;
                self.commentsLabel.alpha = 1;
            }
            
            if(self.useTableView2) {
            } else {
                self.tableViewController1?.inspectPostComments = self.post;
                self.tableViewController1?.performSegueWithIdentifier("toComments", sender: self);
            }
        }
    }
    
    func openPreview() {
        print("opening preview");
        let pNc = storyboard.instantiateViewControllerWithIdentifier("PreviewNavigationController") as! UINavigationController;
        let pVc = pNc.viewControllers.first as! PreviewViewController;
        pVc.image = postImageView.image;
        if(useTableView2) {
            tableViewController2?.presentViewController(pNc, animated: true, completion: nil);
        } else {
            tableViewController1?.presentViewController(pNc, animated: true, completion: nil);
        }
    }
    
    
    @IBAction func onLikeButton(sender: AnyObject) {
        if(favoriteButton.selected) {
            favoriteButton.deselect();
            post?.liked = false;
            var likeCount = likesCount.text;
            if(likeCount == nil || likeCount == "") {
                likeCount = "0";
            }
            setLikesLabel(String(Int(likeCount!)! - 1));
        } else {
            favoriteButton.select();
            
            post?.liked = true;
            var likeCount = likesCount.text;
            if(likeCount == nil || likeCount == "") {
                likeCount = "0";
            }
            setLikesLabel(String(Int(likeCount!)! + 1));
        }
    }
    
    @IBAction func onCommentButton(sender: AnyObject) {
        openComments();
    }
    
    func refreshSuperviewPost(var newPost: Post? = nil) {
        print("refreshing post...");
        
        if(newPost == nil) {
            newPost = Post.cache(post!.objectId!);
        }
        
        post = newPost;
        if(useTableView2) {
            tableViewController2?.posts![indexPathSection!] = post!;
        } else {
            tableViewController1?.posts![indexPathSection!] = post!;
        }
    }
    
}
