//
//  FeedCell.swift
//  SocialNetwork
//
//  Created by c.uraga on 2016/11/13.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption : UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var likeImage: UIImageView!
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(post : Post, img: UIImage? = nil){
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.caption.text = post.caption
//        postImg.image = UIImage(
        likesLabel.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        }
        else {
            let imageUrl = post.imageUrl
            let ref = FIRStorage.storage().reference(forURL: imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: {
                (data, error) in
                if error != nil {
                    print("UNABLE TO DOWNLOAD IMAGE")
                }
                else {
                    print("MESSAGE: Image finished downloading")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedViewController.imageCache.setObject(img, forKey: imageUrl as NSString)
                        }
                    }
                }
            })
            
            
            
        }
        self.likesRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let _ = snapshot.value as? NSNull  {
                self.likeImage.image = UIImage(named: "empty-heart")
            }
            else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
        })
        
        
    }
    
    
    func likeTapped(sender : UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let _ = snapshot.value as? NSNull  {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(like: true)
                self.likesRef.setValue(true)
            }
            else {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(like: false)
                self.likesRef.removeValue()
            }
        })
    }
    

}
