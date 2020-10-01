//  FTSensingSession.swift
//  FaceTracking
//  Created by Marc Valdivieso Merino on 28/09/2020.

//#import "CSSensingSession.h"
//#import "CSModelWriter.h"
//#import "CSRecordingLogModelWriter.h"
//#import <SensingKit/SensingKit.h>
import SensingKit


class FTSensingSession {

    private var modelWriters:Array<FTModelWriter>!
    let sensingKit = SensingKitLib.shared()

    
    init(folderName:String!) {
//        if (self = super.init() != nil)
//        {
//            // Init SensingKitLib
            //self.sensingKitLib = SensingKitLib.sharedSensingKitLib()
//
//            _folderPath = self.createFolderWithName(folderName)
//
//            self.modelWriters = NSMutableArray(capacity:TOTAL_SENSORS)
//            self.recordingLogModelWriter = CSRecordingLogModelWriter(filename:"RecordingLog.csv",
//                                                                                        inPath:self.folderPath)
//        }
//        return self
    }
    
    

    
    func addModelWriter(){
        //let path = AppDelegate.getCurrentPath()
        var a = FTModelWriter(sensorType: SKSensorType.DeviceMotion, withHeader: "DeviceMotionTrial", withFilename: "DeviceMotrionTrial", inPath: "currentPath")
        
    }

    func addModelWriter1(){
        var a = FTModelWriter(sensorType: SKSensorType.Battery, withHeader: "hehe", withFilename: "prova1", inPath: "hola")
        print()
        //modelWriters.append(a)
        
    }
    
    func addLocationModelWriter(){
        var a = FTModelWriter(sensorType: SKSensorType.Location, withHeader: "huhu", withFilename: "prova2", inPath: "hola")
    }
    
    func writeCSV(){
        
        
    }
//    func createFolderWithName(folderName:String!) -> NSURL! {
////        let error:NSError! = nil
////
////        let folderPath:NSURL! = self.applicationDocumentsDirectory().URLByAppendingPathComponent(folderName)
////
////        FileManager.defaultManager().createDirectoryAtURL(folderPath,
////                                 withIntermediateDirectories:true,
////                                                  attributes:nil,
////                                                       error:&error)
////
////        if error != nil {
////            NSLog("Error creating directory: %@", error)
////        }
////
////        return folderPath
//    }
//
//    // Returns the URL to the application's Documents directory.
//    func applicationDocumentsDirectory() -> NSURL! {
//        //return NSFileManager.defaultManager().URLsForDirectory(NSDocumentDirectory, inDomains:NSUserDomainMask).lastObject()
//    }

//    func getModuleWriterWithType(sensorType:SKSensorType) -> CSModelWriter! {
//       // for moduleWriter:CSModelWriter! in self.modelWriters {
//        //    if moduleWriter.sensorType == sensorType { return moduleWriter }
//        // }
//
//        return nil
//    }

    
    func enableBattery(){
        enableSensor(sensorType: SKSensorType.Battery)
    }
    
    
    func enableSensor(sensorType:SKSensorType)  {
        let path  = "ye"
        
        let header = self.sensingKit.csvHeader(for:sensorType)
        print (header)
        let filename:String = String(describing: sensorType)
        print(filename)
        
        if sensingKit.isSensorAvailable(sensorType) {
            // You can access the sensor
        }

        do {
            let conf =  SKLocationConfiguration()
            try sensingKit.register(sensorType, with:conf)
        }
        catch {
            print("Cannot register")
        }
        do {
            try sensingKit.subscribe(to: sensorType, withHandler: { (sensorType, sensorData, error) in

                if (error == nil) {
                    let FTMW = FTModelWriter(sensorType: sensorType, withHeader: header, withFilename: filename, inPath: path)
                    let batteryData = sensorData as! SKLocationData
                    print("Location: \(batteryData)")
                    FTMW.readData(sensorData: batteryData)
                }
            })
        }
        catch {
            print("Cannot subscribe")
            
        }
        
        //modelWriters.append(FTMW)
        // print(modelWriters[0])
        
        //FTMW.readData(sensorData: batteryData)
        
        //modelWriters.add(FTMW)
        
        //print (modelWriters[0])
        

        //String.nonspacedStringWithSensorType(sensorType).stringByAppendingString(".csv")
        
        /*
        // Get the csv header
        let header:String! = self.sensingKitLib.csvHeaderForSensor(sensorType)

        // Create ModelWriter
        let filename:String! = String.nonspacedStringWithSensorType(sensorType).stringByAppendingString(".csv")
        let modelWriter:CSModelWriter! = CSModelWriter(sensorType:sensorType,
                                                                    withHeader:header,
                                                                   withFilename:filename,
                                                                        inPath:self.folderPath)

        // If congiguration is nil, get the default
        if (configuration == nil) {
            configuration = self.getConfigurationFromSensor(sensorType)
        }

        // Register and Subscribe sensor
        if self.sensingKitLib.registerSensor(sensorType, withConfiguration:configuration, error:error)
        {
            let succeed:Bool = self.sensingKitLib.subscribeToSensor(sensorType,
                                                      withHandler:{ (sensorType:SKSensorType,sensorData:SKSensorData!,error:NSError!) in

                                                          if (error == nil) {
                                                              // Feed the writer with data
                                                              modelWriter.readData(sensorData)
                                                          }
                                                      }, error:error)

            if !succeed {
                return false
            }

            // Add sensorType and modelWriter to the arrays
            self.modelWriters.addObject(modelWriter)

            return true
        }
        else {
            return false
        }*/

    }

    func disableSensor(sensorType:SKSensorType, withError error:NSError!) -> Bool {
        /*let succeed:Bool = self.sensingKitLib.deregisterSensor(sensorType, error:error)

        if !succeed {
            return false
        }

        // Search for the moduleWriter in the Array
        let moduleWriter:CSModelWriter! = self.getModuleWriterWithType(sensorType)

        // Close the fileWriter
        moduleWriter.close()

        // Remove fileWriter
        self.modelWriters.removeObject(moduleWriter)
*/
        return true
    }

    func disableAllRegisteredSensors(error:NSError!) -> Bool {
        /*for var i:Int=0 ; i < TOTAL_SENSORS ; i++ {

            let sensorType:SKSensorType = i

            if self.isSensorEnabled(sensorType) {
                if !self.disableSensor(sensorType, withError:error)
                {
                    return false
                }
            }
        return true
         }*/

        return true
    }

    func setConfiguration(configuration:SKConfiguration!, toSensor sensorType:SKSensorType, withError error:NSError!) -> Bool {
        return true//self.sensingKitLib.setConfiguration(configuration, toSensor:sensorType, error:error)
    }

//    func getConfigurationFromSensor(sensorType:SKSensorType) -> SKConfiguration! {
//        /*if self.isSensorEnabled(sensorType)
//        {
//            return self.sensingKitLib.getConfigurationFromSensor(sensorType, error:nil)
//        }
//        else
//        {
//            return self.createConfigurationForSensor(sensorType)
//        }*/
//        return self.sensingKit.getConfigurationFrom(<#T##sensorType: SKSensorType##SKSensorType#>)
//    }
//    func createConfigurationForSensor(sensorType:SKSensorType) -> SKConfiguration! {
//        var configuration:SKConfiguration!
///*
//        switch (sensorType) {
//
//            case Accelerometer:
//                configuration = SKAccelerometerConfiguration()
//                break
//
//            case Gyroscope:
//                configuration = SKGyroscopeConfiguration()
//                break
//
//            case Magnetometer:
//                configuration = SKMagnetometerConfiguration()
//                break
//
//            case DeviceMotion:
//                configuration = SKDeviceMotionConfiguration()
//                break
//
//            case MotionActivity:
//                configuration = SKMotionActivityConfiguration()
//                break
//
//            case Pedometer:
//                configuration = SKPedometerConfiguration()
//                break
//
//            case Altimeter:
//                configuration = SKAltimeterConfiguration()
//                break
//
//            case Location:
//                configuration = SKLocationConfiguration()
//                break
//
//            case iBeaconProximity:
//                configuration = SKiBeaconProximityConfiguration(UUID:NSUUID(UUIDString:"eeb79aec-022f-4c05-8331-93d9b2ba6dce"))
//                break
//
//            case EddystoneProximity:
//                configuration = SKEddystoneProximityConfiguration()
//                break
//
//            case Battery:
//                configuration = SKBatteryConfiguration()
//                break
//
//            case Microphone:
//                configuration = SKMicrophoneConfiguration(outputDirectory:self.folderPath, withFilename:"Microphone")
//                break
//
//            case Heading:
//                configuration = SKHeadingConfiguration()
//                break
//
//            default:
//                NSLog("Unknown sensorSetupType: %ld", (sensorType as! long))
//                abort()*/
//        }
//
//        return configuration
//    }

    func isSensorAvailable(sensorType:SKSensorType) -> Bool {
        return self.sensingKit.isSensorAvailable(sensorType)
    }

    func isSensorEnabled(sensorType:SKSensorType) -> Bool {
        return self.sensingKit.isSensorRegistered(sensorType)
    }

    func sensorsEnabledCount() -> UInt {
        let counter:UInt = 0
/*
        for var i:Int=0 ; i < TOTAL_SENSORS ; i++ {

            let sensorType:SKSensorType = i

            if self.isSensorEnabled(sensorType) {
                counter++
            }
         }
*/
        return counter
    }

    func start(sensorType: SKSensorType) -> Bool {
        do {
            try sensingKit.startContinuousSensing(with: sensorType)
        }
        catch {
            return false
        }
        return true
    }

    func stop(sensorType: SKSensorType, error:NSError!) -> Bool {
        do {
            try sensingKit.stopContinuousSensing(with: sensorType)
        }
        catch {
            return false
        }
        return true
    }

    func close() {
        NSLog("Close Session")

        //self.recordingLogModelWriter.close()
    }

    func deleteSession() {
        
    }

    func addRecordingLog(recordingLog:String!) {
        
}

}
