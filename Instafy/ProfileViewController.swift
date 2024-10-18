//
//  ProfileViewController.swift
//  Instafy
//
//  Created by Hunter Padilla on 11/28/22.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
      
    var profileLink = ""
    @IBAction func onOpenProfile(_ sender: Any) {
        if let url = URL(string: profileLink as! String) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBOutlet weak var profileFollowerCount: UILabel!
    @IBOutlet weak var profilePostCount: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    
    //Variables:
    var posts = [PFObject]()
    var selectedPost: PFObject!
    
    //var profileAlbumList = [[String: Any]]() //Old - creates an empty list array of albums to be filled from the API
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        let layout = profileCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let width = (view.frame.size.width - layout.minimumInteritemSpacing)/3
        layout.itemSize = CGSize(width:width, height: width)
        
        self.getSpotifyCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Pulls the following columns from Parse to add and view.
        let query = PFQuery(className: "Posts")
        query.whereKey("author", equalTo: PFUser.current()!)
        query.includeKeys(["author", "comments", "comments.author", "comments.text", "image"])
        query.limit = 20
        
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.profileCollectionView.reloadData()
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profilePostCount.text = String(posts.count)
        return posts.count //displays the exact albums as necessary.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //print("Collection View Started.")
        
        let post = posts[indexPath.row] // creates a variable post for each individual entry in post
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileAlbumViewCell", for: indexPath) as! ProfileAlbumViewCell
        
        let post_image = post["image"] as! String
        
        let postUrl = URL(string: post_image)
        
        cell.albumView.af_setImage(withURL: postUrl!)
        
        return cell
    }
    
    //gets the current user form the API
    func getSpotifyCurrentUser() {
        //Prepare URL. change based on desired endpoint.
        let url = URL(string: "\(baseUrl)/me") //Sets the Request to get the current user's profile.
        guard let requestUrl = url else { fatalError() }
        
        //Prepare URL Request Object. change based on desired endpoint.
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET" //Specifies the correct method that you are trying to get from the API.
        
        //Two header files are needed. Neither of them need to be changed.
        request.setValue("Bearer \(spotify_access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Attempting to get login info") //Debug
        
        //Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Check for Error. Don't Change
            if let error = error {
                print("Error took place \(error)")
                return
            }
            //Convert HTTP Response Data to a String
            guard let data = data else {return}
            print("Data Debug: \(data)")
            
            //MARK: - The Following lines May change based on the needs of your code -
            //Get the request from the API as a Json file of the whole endpoint
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            //print(dataDictionary) //Debug
            
            //Specify the exact point in the endpoint you with to pull (If there is more than one layer).
            //let followers = dataDictionary["followers"] as! NSDictionary
            //let total_followers = followers["total"]
            //print("Followers: \(total_followers ?? 0)")
            
            let pfpInfo = dataDictionary["images"] as! NSArray
            //print("Here \(pfpInfo.firstObject)")
            let pfpArray = pfpInfo[0] as! NSDictionary
            //print(pfpArray["url"] as! String)
        
            let imageUrl = URL(string:pfpArray["url"] as! String)
            let imageData = try! Data(contentsOf: imageUrl!)
            //Below is old attempt at trying to change UI outside of main
            //self.profileImageView.image = UIImage(data: imageData)
            
            //Use the following when needed to change parameters. Seems to work well.
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                let baseprofile = "https://open.spotify.com/user/"
                self.profileImageView.image = image
                self.profileName.text = dataDictionary["display_name"] as? String
                self.profileUsername.text = dataDictionary["id"] as? String
                //self.profileFollowerCount.text = dataDictionary["followers"] as? String
                //self.profileFollowerCount.text = total_followers as? String
                let followers  = dataDictionary["followers"] as! [String: Any]
                let totalFollowers = followers["total"] // as? String
                //print(totalFollowers ?? 00) //Debug 
                self.profileFollowerCount.text = "\(totalFollowers ?? "Blank")"
                self.profileLink = baseprofile + (dataDictionary["id"] as? String ?? "/")
                
                //let followers = dataDictionary["followers"] as? NSArray
                //let totalFollowers = followers!["total"]
                //print(total_followers)
            }
            
            //print(imageUrl)
            
            //if let imageData = try? Data(contentsOf: imageUrl!)
            //{
                //self.profileImageView.image = UIImage(data: imageData)
            //}
            
            //print("Followers: \(total_followers ?? 0)") //Debug
            //print("pfpURL: \(pfpURL)") //Debug
            
            //print("Response data string:\n \(dataDictionary)") //Debug: prints the whole endpoint info.
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        //print("Works")
        //print("\(posts[indexPath.row])")
        let post = posts[indexPath.row]
        
        if let url = URL(string: post["playlist_link"] as! String) {
            UIApplication.shared.open(url)
        }
    }
}
