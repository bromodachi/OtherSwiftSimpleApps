//
//  FeedViewController.swift
//  SocialNetwork
//
//  Created by c.uraga on 2016/11/07.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var captionField: CustomTextField!
    @IBOutlet weak var imageAddPhoto: ImageCircleView!
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageUploaded = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        DataService.ds.REF_POSTS.observe(.value, with: {
            (snapshot) in
             self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("SNAP : \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
                
            }
            
            self.tableView.reloadData()
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        

        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedCell {
//            var image: UIImage!
            if let img = FeedViewController.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            }
            else {
                cell.configureCell(post: post)
            }
            return cell
        }
        else {
            return FeedCell()
        }
    }
    
    
    
    @IBAction func addImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAddPhoto.image = image
            imageUploaded = true
        } else {
            print("invalid image")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func logOut(_ sender: AnyObject) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
        
    }

    
    @IBAction func postButtonTapped(_ sender: Any) {
        print("MESSAGE: ostButton fired")
        guard let caption = captionField.text, caption != "" else {
             print("MESSAGE: caption needs")
            return
        }
        
        guard let img = imageAddPhoto.image, imageUploaded == true else {
            print("TODO make image optional")
            return
        }
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            print("MESSAGE: imageData Success")
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"

            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imageData, metadata: metadata) {
                (metadata,error) in
                
                if error != nil {

                
                } else{
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    self.imageUploaded = false
                    if let dwlUrl = downloadUrl {
                        self.transferToFirebase(imgUrl: dwlUrl)
                    }
                }
                
        
        }
        }
    }
    
    func transferToFirebase(imgUrl: String){
        print("Mesage: TransferToFirebase")
        let post: Dictionary<String, Any> = [
            "caption" : captionField.text!,
            "imageUrl" : imgUrl,
            "likes": 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageAddPhoto.image = UIImage(named: "add-image")
        tableView.reloadData()
        
    }

    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
