//
//  AppDelegate.swift
//  RedMachine
//
//  Created by Terry Xu on 2021/7/20.
//

import UIKit
import Realm
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setting isExclusiveTouch as true, when two buttons are clicked simultaneously will only respond first click.
        UIButton.appearance().isExclusiveTouch = true
        AppDelegate.configRealm()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

extension AppDelegate {
    class func configRealm() {
        let databaseVersion : UInt64 = 1
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let databasePath = docPath.appending("/defaultDB.realm")
        let config = Realm.Configuration(fileURL: URL(string: databasePath),
                                         schemaVersion: databaseVersion,
                                         migrationBlock: { (migration, oldSchemaVersion) in
                                            // No need to do anyting now.
                                         })
        
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { result in
            switch result {
            case .success:
                print("Realm configure successfully!")
            case .failure(let error):
                print("Realm configure failed：\(error.localizedDescription)")
            }
        }
    }
}

