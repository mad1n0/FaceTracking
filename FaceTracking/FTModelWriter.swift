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
    private var filePath:URL
//    private var outputStream: OutputStream
    private var sensorType: SKSensorType
    private var header: String
    private var filename: String

    init(sensorType:SKSensorType, withHeader header:String!, withFilename filename:String!, inPath path:URL!) {
        
        filePath = path
        self.sensorType = sensorType
        self.header = header
        self.filename = filename
//        outputStream = OutputStream(toFileAtPath: ""?, append: true)

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
        //outputStream.write(sensorData.csvString)
        //NSDictionary *dictionary = sensorData.dictionaryData;
       // self.writeString(csv)
    }
    
    func createCSV(csvString : String) {
            do {
                let path = getDocumentsDirectory()
                let fileURL = URL(fileURLWithPath: "1", relativeTo: path).appendingPathExtension("csv")
                //print(fileURL)
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                let savedData = try Data(contentsOf: fileURL)
                // Convert the data back into a string
                if let savedString = String(data: savedData, encoding: .utf8) {
                    print(savedString + "this is savedString")}
                }
                
            
            catch {
                print("error creating file")
            }

        }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func read() {
    
    }

    func close() {
        //self.outputStream.close()
    }
}

