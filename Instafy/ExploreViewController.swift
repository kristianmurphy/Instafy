//
//  ExploreViewController.swift
//  Instafy
//
//  Created by Hunter Padilla on 11/28/22.
//

import UIKit

class ExploreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    
    var albums = [[String: Any]]() //creates an empty list array of albums to be filled from the API
    var albumList = [[String: Any]]() //creates an empty list array of albums to be filled from the API
    
    var album_name = [String: Any]()
    var album_image = [String: Any]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //MARK: Layout
        //This section of code is to make sure the layout of the collection view is correct.
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        //self.getNewReleases()
        print("Getting new releases...")
        
        //Prepare URL. change based on desired endpoint.
        let url = URL(string: "\(baseUrl)/browse/new-releases?country=US&limit=30") //Sets the Request to get the current user's recommendations
        guard let requestUrl = url else { fatalError() }
        //print(requestUrl) //Debug
        
        //Prepare URL Request Object. change based on desired endpoint.
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET" //Specifies the correct method that you are trying to get from the API.

        //Two header files are needed. Neither of them need to be changed.
        request.setValue("Bearer \(spotify_access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        //Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                //Check for Error. Dont Change
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                //Convert HTTP Response Data to a String
                if let data = data {
                    
                    //MARK: - The Following lines May change based on the needs of your code -
                    //Get the request from the API as a Json file of the whole endpoint
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    //print(dataDictionary) //Debug
                    
                    let albums = dataDictionary["albums"] as! [String: Any]
                    print("Explore Here")
                    print(albums) //Debug
                    
                    self.albumList = albums["items"] as! [[String: Any]]
                    
                    print(self.albumList.count)
                    
                    self.collectionView.reloadData()
                }
            }
            
            
            //print(self.albumList)
            
            
                
            
            
//            let albumName = albumFix["name"] as! String //finds the name within the above dictionary.
//            self.album_name = albumName
//            print(albumName) //Debug
            
            
            
        }
        task.resume()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("Collection View Count Started.")
        //print(self.albumList.count)
        return albumList.count //displays the exact albums as necessary.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumGridCell", for: indexPath) as! AlbumGridCell
        
        print("Collection View Started.")
        
        let album = albumList[indexPath.row] // creates a variable album for each individual entry in albums
        
        let title_name = album["name"] as! String
        
        let images = album["images"] as! [[String: Any]]
        
        let image = images[1] //This is a dictionary
        
        let album_image = image["url"] as! String
        
        let albumUrl = URL(string: album_image)
        
        
        cell.albumView.af_setImage(withURL: albumUrl!)
        
        cell.albumLabel.text = title_name
        
        return cell
    }
    
    func getNewReleases() {
        
        print("Getting new releases...")
        
        //Prepare URL. change based on desired endpoint.
        let url = URL(string: "\(baseUrl)/browse/new-releases?country=US&limit=20") //Sets the Request to get the current user's recommendations
        guard let requestUrl = url else { fatalError() }
        //print(requestUrl) //Debug
        
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
            
            //MARK: - The Following lines May change based on the needs of your code -
            //Get the request from the API as a Json file of the whole endpoint
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

            //print(dataDictionary) //Debug
            
            let albums = dataDictionary["albums"] as! [String: Any]
            //print(albums) //Debug
            
            self.albumList = albums["items"] as! [[String: Any]]
            
            print(self.albumList.count)

            
            //print(self.albumList)
            
            
                
            
            
            //let albumName = albumFix["name"] as! String //finds the name within the above dictionary.
            //self.album_name = albumName
            //print(albumName) //Debug
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        //print("Works")
        //print("\(posts[indexPath.row])")
        let post = albumList[indexPath.row]
        
        if let url = URL(string: post["playlist_link"] as! String) {
            UIApplication.shared.open(url)
        }
    }
}
