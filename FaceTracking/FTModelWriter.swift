//
//  FTModelWriter.swift
//  FaceTracking
//
//  Created by Marc Valdivieso Merino on 28/09/2020.
//

//#import "CSModelWriter.h"
import SensingKit

class FTModelWriter {
    let sensingKit = SensingKitLib.shared()
    private var filePath:String
    private var outputStream: String
    private var sensorTyp: SKSensorType
    private var header: String
    private var filename: String

    init(sensorType:SKSensorType, withHeader header:String!, withFilename filename:String!, inPath path:String!) {
        
        print("writer on")
        filePath = path
        sensorTyp = sensorType
        self.header = header
        self.filename = filename
        outputStream = (filename + "ModelWriter ON")
        setupTrialSensor()
        setupSensor()
//        readData(LocationData)
//            _sensorType = sensorType
//            let filePath:NSURL! = path.URLByAppendingPathComponent(filename)
//
//            self.filePath = filePath
//            self.outputStream = NSOutputStream(URL:filePath, append:true)
//            self.outputStream.delegate = self
//            self.outputStream.open()
//
//            // Write header
//            self.writeString(String(format:"%@\n", header))
        
    }
    
    func setupSensor(){
        
        
    }
    
    func setupTrialSensor(){
        if sensingKit.isSensorAvailable(SKSensorType.Location) {
            // You can access the sensor
            print("sensingkit Location available")
        }

        do {
            try sensingKit.register(SKSensorType.Location)
            print ("hola")
        }
        catch {
            // Handle error
        }
        do {
            try sensingKit.subscribe(to: SKSensorType.Location, withHandler: { (sensorType, sensorData, error) in

                if (error == nil) {
                    let LocationData = sensorData as! SKLocationData
                    print("Hi from subscribe location datareading")
                    print("Battery Level: \(LocationData)")
                    self.readData(sensorData: LocationData)
                }
            })
        }
        catch {
            print("F")// Handle error
        }
        
    }
    
    func readData(sensorData:SKSensorData!) {
        let csv:String! = String(format:"%@\n", sensorData.csvString)
        // debug
        NSLog("%@", csv)
        print(sensorData.csvString + "thisiscsvStrng")
        //NSDictionary *dictionary = sensorData.dictionaryData;
       // self.writeString(csv)
    }
    
    func createCSV(from recArray:[Dictionary<String, AnyObject>]) {
            var csvString = "\("Employee ID"),\("Employee Name")\n\n"
            for dct in recArray {
                csvString = csvString.appending("\(String(describing: dct["EmpID"]!)) ,\(String(describing: dct["EmpName"]!))\n")
            }

            let fileManager = FileManager.default
            do {
                let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                let fileURL = path.appendingPathComponent("CSVRec.csv")
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("error creating file")
            }

        }
    
    func writeString(string:String!) {
    //    let data:Data! = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:false)
     //   self.outputStream.write(data.bytes, maxLength:data.length)
    }

    func close() {
        //self.outputStream.close()
    }
}

