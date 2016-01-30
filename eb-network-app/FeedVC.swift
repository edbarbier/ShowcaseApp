//
//  FeedVC.swift
//  eb-network-app
//
//  Created by Edouard Barbier on 13/01/16.
//  Copyright © 2016 Edouard Barbier. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    var posts = [Post]() //Initializing this here so we can use posts.count in numberofrowsinsection without getting a crash
    
    static var imgCache = NSCache()
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 358
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            cell.request?.cancel() //cancel request if the cell we are reusing has a request ongoing so we make sure we don't download the wrong image
            
            var img: UIImage?
            
            if let url = post.imgUrl {
                img = FeedVC.imgCache.objectForKey(url) as? UIImage
            } else {
                
            }
            
            cell.configureCell(post, img: img)
            return cell
        } else {
            return PostCell()
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imgUrl == nil {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    //func is depreciated - use didFinishPickingMediaWithInfo if need to work with videos
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImage.image = image
        imageSelected = true
        
    }
    
    

    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func makePost(sender: AnyObject) {
        
        if let txt = postField.text where txt != "" {
            
            //checking if there is an image, there will be since we're using the camera img in the UIImageView: case to handle oursleves later - chekc that the image isn't the camera
            if let img = imageSelectorImage.image where imageSelected == true {
                
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "02CDKTWY0efd37b449ddb8d09e94caf1029a6fdf".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: imgData, name: "fileupload",fileName: "image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")

                    }) { encodingResult in //this is what happens when encoding is done. Variable will tell us if enconding was successfull or not.
                        
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            upload.responseJSON(completionHandler: { response in
                                if let info = response.result.value as? Dictionary<String, AnyObject> {
                                    if let links = info["links"] as? Dictionary<String, AnyObject> {
                                        if let imgLink = links["image_link"] as? String {
                                            
                                            print("LINK: \(imgLink)")
                                            self.postToFirebase(imgLink)
                                        }
                                    }
                                }
                            })
                        case .Failure(let error):
                        print(error)
                        print(error)
                        }
                    }
            } else {
                self.postToFirebase(nil)
            }
        }
    }
    
    func postToFirebase(imgUrl: String?) {
            
        var post: Dictionary<String, AnyObject> = ["description": postField.text!,"likes": 0]
            
        if imgUrl != nil {
            post["imgUrl"] = imgUrl!
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        postField.text = ""
        postField.endEditing(true)
        imageSelectorImage.image = UIImage(named: "camera")
        imageSelected = false
        tableView.reloadData()
    }
            
}
        

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

