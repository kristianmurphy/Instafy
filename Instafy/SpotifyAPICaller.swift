//
//  APIManager.swift
//  Instafy
//
//  Created by Dan on 1/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import OAuth2_Swift
//import BDBOAuth1Manager

//MARK: -Order of operations
//QAuth2.0 -> https://accounts.spotify.com/api/token (using refresh_token frmo QAuth2.0) -> any other call ( using access_token from https://accounts.spotify.com/api/token)




//let fullAuthURL = "\(authURL)response_type=code&client_id=\(clientID)&scope=\(scope)&redirect_uri=\(redirectURL)&show_dialog=TRUE"


//func authSpotify() {
//    if let app = UIApplication.shared.delegate as? AppDelegate {
//      app.auth = OAuth2Client(configuration: OAuth2Configuration(clientId: clientID, authURL: authURL, tokenURL: "https://accounts.spotify.com/api/token", scope: scope, redirectURL: redirectURL, responseType: "code"))
//      //app.auth.configuration.parameters = ["access_type":"offline", "hl":"en"]
//      app.auth.authorize(from: self)
//      app.auth.clientIsLoadingToken = {
//        //self.spinner?.startAnimating()
//        //self.progressLabel?.text = "Loading OAuth2 token ..."
//          print("Loading OAuth2 token ...")
//      }
//      app.auth.clientDidFinishLoadingToken = {
//        //self.spinner?.stopAnimating()
//        //self.progressLabel?.text = "token:\n\(app.auth.token?.accessToken ?? "No token !!!")"
//          print("token:\n\(app.auth.token?.accessToken ?? "No token !!!")")
//      }
//      app.auth.clientDidFailLoadingToken = { error in
//        //self.spinner?.stopAnimating()
//        //self.progressLabel?.text = "error:\n\(error.localizedDescription)"
//          print("error:\n\(error.localizedDescription)")
//      }
//    }
//  }


















//class SpotifyAPICaller: BDBOAuth1SessionManager {
//
//    //loads the base URL, the consumerKey (clientID), and consumerSecret (clientSecret) insto a static variable.
//    static let client = SpotifyAPICaller(baseURL: URL(string: baseAuthURL), consumerKey: clientID, consumerSecret: clientSecret, accessToken: )
//
//    var loginSuccess: (() -> ())?
//    var loginFailure: ((Error) -> ())?
//
//    //Function Requests an access token from the Spotify API
//    func handleOpenUrl(url: URL){
//        let requestToken = BDBOAuth1Credential(queryString: url.query)
//        SpotifyAPICaller.client?.fetchAccessToken(withPath: "/api/token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
//            self.loginSuccess?()
//        }, failure: { (error: Error!) in
//            self.loginFailure?(error)
//        })
//    }
//
//    //function for logging in the user into the application through authentication.
//    func login(url: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
//
//        print(fullAuthURL) //Debug: displays the full URL for the authentication process.
//
//
//        loginSuccess = success
//        loginFailure = failure
//
//        SpotifyAPICaller.client?.deauthorize()
//
//        //requests a authentication token from the SPotify API
//        SpotifyAPICaller.client?.fetchRequestToken(withPath: url, method: "GET", callbackURL: URL(string: redirectURI), scope: scopes, success: { (requestToken: BDBOAuth1Credential!) -> Void in
//
//            let url = URL(string: "\(baseAuthURL)api/token=\(requestToken.token!)")! //sets url to baseAuthURL and the token endpoint.
//            UIApplication.shared.open(url)
//        }, failure: { (error: Error!) -> Void in
//            print("Error: \(error.localizedDescription)")
//            self.loginFailure?(error)
//        })
//    }
//
//    func logout (){
//        deauthorize()
//    } //logs the user out of the application through deauthorization
//}
