//
//  LoginViewController.swift
//  Instafy
//
//  Created by Alex Reburn on 11/15/22.
//

import UIKit
import Parse
import OAuth2_Swift

//MARK: Constants
//These are the Constants that will be used throughout the code for accessing the Spotify API.
let clientID = "cf17f687a92940378c5f30d9acd2c4ea" //the ID of the Client server requesting the API.
let clientSecret = "6ef12f6c2b0247c48ca224897d87c266" //the Secret key to the Client Server.
let client_credential = "Y2YxN2Y2ODdhOTI5NDAzNzhjNWYzMGQ5YWNkMmM0ZWE6NmVmMTJmNmMyYjAyNDdjNDhjYTIyNDg5N2Q4N2MyNjY" //Encoded from the previous two constants. used for API requests.

let scope = "user-read-private user-library-read" //Current scope that the user is requesting.
let authUrl = "https://accounts.spotify.com/authorize" //the URL for the authentication Process.
var isAuthDone = false //Variable to check if the authentication went through.

//Variables that will likely be used repeatedly
let baseUrl = "https://api.spotify.com/v1" //this is the base endpoints for every Spotify API request.
var spotify_access_token = ""

var spotify_account_id = ""

var currentUsername = ""


//MARK: Results of Authentication
//Return for the authentication
struct Result: Codable {
    var access_token: String
    var token_type: String
    var expires_in: Int
    var scope: String
}

    



class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //Function that calls for the authentication of the user and loginSegue.
    @IBAction func onLoginButton(_ sender: Any) {
        
        if isAuthDone == false {
            self.authSpotify() //Calls for the authentication at the begining of the login process so that the token is available for the onLoginButton function.
            
        }else if isAuthDone == true {
            //Gaining access to the User information
            self.getSpotifyCurrentUser() //Function calls for the current spotify user from the API
            
            // Attempt to log in with current spotify account
            PFUser.logInWithUsername(inBackground: spotify_account_id, password: spotify_account_id)
            { (user, error) in
                if user != nil { // If valid, log in and segue
                    self.performSegue(withIdentifier: "loginSegue", sender: nil) //Takes the user to the FeedViewController
                }
                else{ // If user does not exist, create parse user using Spotify account
                    var user = PFUser()
                    user.username = spotify_account_id
                    user.password = spotify_account_id
                    
                    user.signUpInBackground { (success, error) in
                        if success { // If sign up success, continue segue
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                        else{
                            print("Error: \(String(describing: error?.localizedDescription))")
                        }
                        //print("Error: \(String(describing: error?.localizedDescription))")
                    }
                }
            }
            //TODO: - prepare (for segue) on bottom of file to send data over (baseURL and access token)
        }
    }
    
    //Function Authorizes the Current User so that they can access the Spotify Web API
    func authSpotify() {
        if let app = UIApplication.shared.delegate as? AppDelegate {
            
            //MARK: access Token
            app.auth = OAuth2Client(configuration: OAuth2Configuration(clientId: "cf17f687a92940378c5f30d9acd2c4ea", clientSecret: "6ef12f6c2b0247c48ca224897d87c266", authURL: "https://accounts.spotify.com/authorize", tokenURL: "https://accounts.spotify.com/api/token", scope: "user-read-private user-read-email user-library-read", redirectURL: "instafy://callback"))
            app.auth.configuration.parameters = ["access_type":"offline", "hl":"en"]
            app.auth.authorize(from: self)
            app.auth.clientIsLoadingToken = {
                print("Loading OAuth2 token ...")
            }
            app.auth.clientDidFinishLoadingToken = {
                print("token:\n\(app.auth.token?.accessToken ?? "No token !!!")")
                
                //MARK: Refresh Token
                let token = app.auth.token?.refreshToken

                //Prepare URL
                let url = URL(string: "https://accounts.spotify.com/api/token")
                guard let requestUrl = url else { fatalError() }
                // Prepare URL Request Object
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "POST"

                //Two header files are needed.
                request.setValue("Basic \(client_credential)", forHTTPHeaderField: "Authorization")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

                //print("Basic \(client_credential)") //Debug

                //HTTP Request Parameters which will be sent in HTTP Request Body
                let postString = "grant_type=refresh_token&refresh_token=\(String(token ?? "NA"))"
                
                //print("It runs up to here.") //Debug

                //Set HTTP Request Body
                request.httpBody = postString.data(using: String.Encoding.utf8)
                //Perform HTTP Request
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                    //Check for Error
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }

                    //Convert HTTP Response Data to a String
                    guard let data = data else {return}
                            do{
                                let dataString = try JSONDecoder().decode(Result.self, from: data)
                                print("Response data string:\n \(dataString.access_token)")
                                
                                spotify_access_token = dataString.access_token
                                
                                isAuthDone = true
                                print("Auth is done.")
                                
                            }catch let jsonErr{
                                print(jsonErr)
                                let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                                print("Data: \(dataString!)")
                           }
                }
                
                task.resume()
            }
            app.auth.clientDidFailLoadingToken = { error in
                print("error:\n\(error.localizedDescription)")
            }
        }
        
    }
    
    
    //MARK: - Code for getting the current user from Spotify API. Can convert for any other endpoint.
    func getSpotifyCurrentUser() {
        //Prepare URL. change based on desired endpoint.
        let url = URL(string: "\(baseUrl)/me") //Sets the Request to get the current user's profile.
        guard let requestUrl = url else { fatalError() }
        print(requestUrl)
        //Prepare URL Request Object. change based on desired endpoint.
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET" //Specifies the correct method that you are trying to get from the API.

        //Two header files are needed. Neither of them need to be changed.
        request.setValue("Bearer \(spotify_access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        print("Attempting to get login info") //Debug

        //Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Check for Error. Dont Change
            if let error = error {
                print("Error took place \(error)")
                return
            }
            //Convert HTTP Response Data to a String
            guard let data = data else {return}
            //print("Data Debug: \(data)")
            
            //MARK: - The Following lines May change based on the needs of your code -
            //Get the request from the API as a Json file of the whole endpoint
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        
            //Specify the exact point in the endpoint you with to pull (If there is only one layer).
            let currentUserId = dataDictionary["id"] as! String //TODO: Set the DB to record this instead of made-up username and password
            print("CurrentUserId: \(currentUserId)") //Debug
            
            spotify_account_id = currentUserId // Important - used for log and sign up on the LoginViewController
            
            //Specify the exact point in the endpoint you with to pull (If there is only one layer).
            let currentUser = dataDictionary["display_name"] as! String //TODO: Set the DB to record this instead of made-up username and password
            print("CurrentUser: \(currentUser)") //Debug
            
            
            currentUsername = currentUser
        }
        task.resume()
    }
}
