//
//  AppDelegate.swift
//  LapApp
//
//  Created by Natalia Kazakova on 13/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var container: NSPersistentContainer!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        createContainer { container in
            self.container = container
            if let nc = self.window?.rootViewController as? UINavigationController,
                let vc = nc.topViewController as? ViewController {
                vc.context = container.viewContext
                vc.backgroundContext = container.newBackgroundContext()
            }
        }
        
        return true
    }
}

//MARK: - Core Data stack
/***************************************************************/

extension AppDelegate {
    func createContainer(completion: @escaping (NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores(completionHandler: { _, error in
            guard error == nil else {
                fatalError("Failed to load store")
            }
            DispatchQueue.main.async { completion(container) }
        })
    }
}
