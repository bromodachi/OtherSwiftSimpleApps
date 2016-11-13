//
//  Post.swift
//  SocialNetwork
//
//  Created by c.uraga on 2016/11/13.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import Foundation
import Firebase

class Post {

    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    var caption: String{
        return _caption
    }
    var imageUrl: String{
        return _imageUrl
    }
    var likes: Int{
        return _likes
    }
    var postKey: String{
        return _postKey
    }
    
    init(caption: String, imageURL: String, likes: Int) {
        self._caption = caption
        self._imageUrl = imageURL
        self._likes = likes
    }
    
    init(postKey : String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        if let imageUrl = postData["imageUrl"] as? String  {
            self._imageUrl = imageUrl
        }
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func adjustLikes(like : Bool){
        if like {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        //this is terrible, change it.
        _postRef.child("likes").setValue(_likes)
        
    }
    
}
