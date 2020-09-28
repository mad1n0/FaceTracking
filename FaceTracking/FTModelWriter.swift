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

    init(sensorType:SKSensorType, withHeader header:String!, withFilename filename:String!, inPath path:String!) {
        
        print("writer on")
        filePath = path
        outputStream = (filename + "ModelWriter ON")
        print(outputStream)
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

        // debug
        NSLog("%@", csv)
        //NSDictionary *dictionary = sensorData.dictionaryData;

       // self.writeString(csv)
    }

    func writeString(string:String!) {
    //    let data:Data! = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:false)
     //   self.outputStream.write(data.bytes, maxLength:data.length)
    }

    func close() {
        //self.outputStream.close()
    }
}

