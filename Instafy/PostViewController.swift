//
//  PostViewController.swift
//  Instafy
//
//  Created by Alex Reburn on 11/15/22.
//

import UIKit
import Parse //for placing the post into the Parse DB.


//Global Variables
var imageURL = ""
var newID = ""

//Struct necessary for decoding data returned from SpotifyAPI
struct imageData: Decodable{
    
    var height: Int?
    var url: String
    var width: Int?
    
}


class PostViewController: UIViewController {

    
    @IBOutlet weak var albumCoverView: UIImageView!
    
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var albumIDField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    //Function allows the user to post playlists and their opinions on said playlists.
    @IBAction func onPostButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        post["author"] = PFUser.current()!
        post["caption"] = commentField.text
        
        post["playlist_link"] = albumIDField.text
        post["playlist_ID"] = newID
        
        post["image"] = imageURL
        
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func onSetAlbumIDButton(_ sender: Any) {
        
        //removes everything in the link before the ID in the link
        newID = (albumIDField.text?.replace(target: "https://open.spotify.com/playlist/", withString: ""))!
    
        //Removes everything in the link after the ? in the link
        newID = newID.components(separatedBy: "?")[0]
        
        
        //Retrieves the image of the playlist necessary for posts
        retrievePlaylistImage()
        
        //Sets the image in the post screen for preview
        setImage(from: imageURL)

    }
    
    
    
    
    
    //Function for the cancel button.
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func retrievePlaylistImage() {
        
        
        //Prepare PlaylistID
        let albumID: String = (newID)
        print("debug ID: \(albumID)")
        
        //Prepare URL. change based on desired endpoint.
        let url = URL(string: "\(baseUrl)/playlists/\(albumID)/images") //Sets the Request to get the playlist cover image
        guard let requestUrl = url else { fatalError() }

        //Prepare URL Request Object. change based on desired endpoint.
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET" //Specifies the correct method that you are trying to get from the API.

        //Two header files are needed. Neither of them need to be changed.
        request.setValue("Bearer \(spotify_access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        //Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Check for Error. Dont Change
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            //Convert HTTP Response Data to a String
            guard let data = data else {return}
                    do{
                        let dataString = try JSONDecoder().decode([imageData].self, from: data)
                        //print("Response data string:\n \(dataString[0].url)")
                        
                        imageURL = dataString[0].url
                        print("ImageURL: \(imageURL)")
                        
                        
                    }catch let jsonErr{
                        print(jsonErr)
                        let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        print("Data: \(dataString!)")
                   }
        }
        
        task.resume()
    }
    
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                
                self.albumCoverView.image = image
            }
        }
    }
}

    
    
extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

