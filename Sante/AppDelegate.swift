//
//  AppDelegate.swift
//  Sante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    // adress IP static, care for updates !
    let apiPersonUrl = "http://10.1.0.100:3000/persons"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        importData()
        refreshFromServer()
        
        return true
    }
    
    //fonction de refresh
    func refreshFromServer() {
        let url = URL(string: apiPersonUrl)!
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            guard let data = data else {
                return
            }
            
            let dictionnary = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            guard let jsonDict = dictionnary as? [[String: Any]] else {
                return
            }
            
            self.updateFromJsonData(json: jsonDict)
        }
        task.resume()
    }
    
    //Comment on récupère les données
    func updateFromJsonData(json: [[String: Any]]) {
        
        //Supprimer
        let fetchRequest = NSFetchRequest<PatientData> (entityName: "PatientData")
        
        let patients = try! persistentContainer.viewContext.fetch(fetchRequest)
        for patient in patients {
            persistentContainer.viewContext.delete(patient)
        }
        
        try! persistentContainer.viewContext.save()
        
        //Lire
        for dict in json {
            if let dictionnary = dict as? [String:Any] {
                let id = dictionnary["id"] as? Int64 ?? 0
                let firstName = dictionnary["surname"] as? String ?? "Error"
                let lastName = dictionnary["lastname"] as? String ?? "Error"
                let pictureUrl = dictionnary["pictureUrl"] as? String ?? "Error"
                
                let patientData = PatientData(entity: PatientData.entity(), insertInto: persistentContainer.viewContext)
                patientData.name = lastName
                patientData.forename = firstName
                patientData.serverID = id
                patientData.pictureUrl = pictureUrl
                print(patientData.getName())
            }
        }
        do {
            try self.persistentContainer.viewContext.save()
        }catch {
            print("error")
        }
    }
    
    //Comment on rajoute les données
    func importData() {
        //Check if import as been done , if UserDefault got key dataImported
        // if false importData and got dataImported true
        let dataImported = UserDefaults.standard.value(forKey: "isDataimported") as? Bool ?? false
        
        if !dataImported {
            //read data from names.plist
            
            let fileUrl = Bundle.main.url(forResource: "names", withExtension: "plist")
            guard let url = fileUrl, let array = NSArray(contentsOfFile: url.path) else {
                return
            }
            //Create Data in core data
            for dict in array {
                if let dictionnary = dict as? [String:Any] {
                    let firstName = dictionnary["firstname"] as? String ?? "Error"
                    let lastName = dictionnary["lastname"] as? String ?? "Error"
                    let pictureUrl = dictionnary["pictureUrl"] as? String ?? "Error"
                    let gender = dictionnary["Gender"] as? String ?? "Error"
                    
                    let patientData = PatientData(entity: PatientData.entity(), insertInto: persistentContainer.viewContext)
                    patientData.name = lastName
                    patientData.forename = firstName
                    patientData.gender = gender
                    patientData.pictureUrl = pictureUrl
                }
            }
            
            UserDefaults.standard.setValue(true, forKey: "isDataImported")
            
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    var persistentContainer: NSPersistentContainer = { // au lieu de lazy var ; on a viré le print aussi
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension UIViewController {
    var persistentContainer: NSPersistentContainer {
        get {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            return appdelegate.persistentContainer
        }
    }
}
