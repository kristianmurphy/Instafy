//
//  AppDelegate.swift
//  Instafy
//
//  Created by Laura Parusel on 11/14/22.
//

import UIKit
import Parse
import OAuth2_Swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var auth = OAuth2Client(configuration: OAuth2Configuration())
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // --- Copy this only
        
        let parseConfig = ParseClientConfiguration {
                $0.applicationId = "L9BcGV844iraChtfmOYv9nvPpd3sgiadOOONVdBG" // <- UPDATE
                $0.clientKey = "aIGhLxfjTv3T4hmbCP5OzoNDdLoUbCRG5c5n2phL" // <- UPDATE
                $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
        
        // --- end copy


        return true
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //SpotifyAPICaller.client?.handleOpenUrl(url: url)
        return true
    }


}

