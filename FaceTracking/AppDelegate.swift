//
//  AppDelegate.swift
//  FaceTracking
//
//  Created by Marc Valdivieso Merino on 22/09/2020.
//


import UIKit
import CoreData
import SensingKit




@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let sensingKit = SensingKitLib.shared()
    let fTSensingSession = FTSensingSession(folderName: "foldername")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("hola des de didfinish");
        setupSensingKitBattery()
        if(fTSensingSession.isSensorEnabled(sensorType: SKSensorType.Battery)){
            print("FTSensingSession funcionant")
            fTSensingSession.addModelWriter()
        }
        //setupFTSensingSession
        //setupSensingKitDeviceMotion()
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FaceTracking")
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
    
    func setupSensingKitBattery () {
        
        print("holasetup")
        if sensingKit.isSensorAvailable(SKSensorType.Battery) {
            // You can access the sensor
            print("sensingkit battery available")
        }

        do {
            try sensingKit.register(SKSensorType.Battery)
        }
        catch {
            // Handle error
        }
        do {
            try sensingKit.subscribe(to: SKSensorType.Battery, withHandler: { (sensorType, sensorData, error) in

                if (error == nil) {
                    let batteryData = sensorData as! SKBatteryData
                    print("Battery Level: \(batteryData)")
                }
            })
        }
        catch {
            // Handle error
        }
        
        do {
            try sensingKit.startContinuousSensing(with:SKSensorType.Battery)
        }
        catch {
            // Handle error
        }
        
    }
    
    func setupSensingKitDeviceMotion () {
        
        print("holasetup DeviceMotion")
        if sensingKit.isSensorAvailable(SKSensorType.DeviceMotion) {
            // You can access the sensor
            print("sensingkit battery available")
        }

        do {
            try sensingKit.register(SKSensorType.DeviceMotion)
        }
        catch {
            // Handle error
            print("DeviceMotion not available")
        }
        do {
            try sensingKit.subscribe(to: SKSensorType.DeviceMotion, withHandler: { (sensorType, sensorData, error) in

                if (error == nil) {
                    let DeviceMotionData = sensorData as! SKDeviceMotionData
                    print("DeviceMotion Level: \(DeviceMotionData)")
                }
            })
        }
        catch {
            // Handle error
        }
        
        do {
            try sensingKit.startContinuousSensing(with:SKSensorType.DeviceMotion)
        }
        catch {
            // Handle error
        }
        
    }

}
