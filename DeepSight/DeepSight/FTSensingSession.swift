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
    var FTMW:FTModelWriter!
    var objCw: CSModelWriter?
    var filename: String?
    var zipname : String?
    var newwriter : Bool?
    
    init(folderName:String!) {

    }
    
    func getModelWriters() -> Array<FTModelWriter>{
        return self.modelWriters
    }
    

    func getObjCw() -> CSModelWriter{
        return self.objCw!
    }
    
    func stopCSWriter(){
        self.objCw?.close()
        self.newwriter = true
        
    }
    
    func getDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        let now = df.string(from: Date())
        return now
    }
    
   
    
    func getFTMW() -> FTModelWriter {
        return self.FTMW
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
    func enableSensor(sensorType:SKSensorType)  {
        let path  = getDocumentsDirectory()
        let sensorType = SKSensorType.DeviceMotion
        let header = self.sensingKit.csvHeader(for:sensorType)
        let date = getDate()
        self.filename = date.appending(".csv")
        self.zipname = date.appending(".zip")
        if sensingKit.isSensorAvailable(sensorType) {
            // You can access the sensor
        }

        do {
            let conf =  SKDeviceMotionConfiguration()
            try sensingKit.register(sensorType, with:conf)
        }
        catch {
            print("Cannot register")
        }
        do {
            try sensingKit.subscribe(to: sensorType, withHandler: { (sensorType, sensorData, error) in

                if (error == nil) {
                    self.FTMW = FTModelWriter(sensorType: sensorType, withHeader: header, withFilename: self.filename, inPath: path)
                    let deviceData = sensorData as! SKDeviceMotionData
                    if (self.objCw == nil || self.newwriter == true) {
                        self.objCw = self.FTMW.objCwriter()
                        self.newwriter = false
                    }
                    // print("Location: \(batteryData)")
                    
                    self.FTMW.readData(sensorData: deviceData, csMW: self.objCw!)
                    
                }
            })
        }
        catch {
            print("Cannot subscribe")
            
        }

    }

    
    func zipData() -> URL {
        
        return self.FTMW.zipData()
        
    }
    
    
    
    func sendRequestRequest(){
        let path = getDocumentsDirectory()
        let zipURL = URL(fileURLWithPath: self.zipname!, relativeTo: path)
        self.FTMW.sendRequestRequest(fileURL: zipURL)
    }


    func setConfiguration(configuration:SKConfiguration!, toSensor sensorType:SKSensorType, withError error:NSError!) -> Bool {
        return true//self.sensingKitLib.setConfiguration(configuration, toSensor:sensorType, error:error)
    }



    func isSensorAvailable(sensorType:SKSensorType) -> Bool {
        return self.sensingKit.isSensorAvailable(sensorType)
    }

    func isSensorEnabled(sensorType:SKSensorType) -> Bool {
        return self.sensingKit.isSensorRegistered(sensorType)
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

    func stop(sensorType: SKSensorType) -> Bool {
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

