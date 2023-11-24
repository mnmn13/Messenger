//
//  AppDelegate.swift
//  Messenger
//
//  Created by MN on 17.11.2022.
//

import UIKit
import Firebase
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var appCoordinator: AppCoordinator?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   
        FirebaseApp.configure()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
           appCoordinator = AppCoordinator(window: window)
        
        FirebaseRealtimeDatabaseManager.shared.goOnline()
        OpenAIManager.shared.openAIInit()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        FirebaseRealtimeDatabaseManager.shared.goOffline()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        FirebaseRealtimeDatabaseManager.shared.goOnline()
    }
    
    
}

