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
    
 
    
    func readData(sensorData:SKSensorData!) {
        
        
        let csv:String! = String(format:"%@\n", sensorData.csvString)
        NSLog("%@", csv)
        print(sensorData.csvString + "thisiscsvStrng")
        createCSV(csvString: sensorData.csvString)
        //NSDictionary *dictionary = sensorData.dictionaryData;
       // self.writeString(csv)
    }
    
    func createCSV(csvString : String) {


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

