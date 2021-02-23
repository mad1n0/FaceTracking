//
//  FTModelWriter.swift
//  FaceTracking
//
//  Created by Marc Valdivieso Merino on 28/09/2020.
//

//#import "CSModelWriter.h"
import SensingKit
import SSZipArchive
import Alamofire
import ZIPFoundation

class FTModelWriter {
    let sensingKit = SensingKitLib.shared()
    private var filePath:URL
//    private var outputStream: OutputStream
    private var sensorType: SKSensorType
    private var header: String
    private var filename: String
    private var outputStream: OutputStream
    private var datastring: String

    init(sensorType:SKSensorType, withHeader header:String!, withFilename filename:String!, inPath path:URL!) {
        
        self.filePath = path
        self.sensorType = sensorType
        self.header = header
        self.filename = filename
        self.datastring = ""
        self.outputStream = OutputStream(toFileAtPath: filePath.absoluteString, append: true)!

        datastring.append(header)
        
    }
    
 
    
    func readData(sensorData:SKSensorData!, csMW:CSModelWriter) {
        //let csv:String! = String(format:"%@\n", sensorData.csvString)
        //NSLog("%@", csv)
        //print(sensorData.csvString + "thisiscsvStrng")
        //datastring.append("\n")
        //datastring.append(csv)
        writeData(sensorData:sensorData, csMW:csMW)
    }
    
    func writeData(sensorData:SKSensorData!, csMW:CSModelWriter){
        //createCSV(csvString:datastring, upload:true)
        
        csMW.read(sensorData)
        
        
    }
    
    

    
    func getFilename() -> String {
        return self.filename
    }
    
    func objCwriter() -> CSModelWriter{
        return CSModelWriter.init(sensorType: self.sensorType, withHeader: self.header, withFilename: self.filename, inPath: self.filePath)
    }
    

    
    
    func zipData() -> URL {
        let fileManager = FileManager()
        let currentWorkingPath = getDocumentsDirectory()
        var sourceURL = URL(fileURLWithPath: currentWorkingPath.absoluteString)
        
        sourceURL.appendPathComponent(self.filename)
        //ourceURL.appendPathExtension("csv")
        var destinationURL = URL(fileURLWithPath: currentWorkingPath.absoluteString)
        self.filename.removeLast(4)
        self.filename.append("_SK")
        destinationURL.appendPathComponent(filename)
        destinationURL.appendPathExtension("zip")
    
        do {
            try fileManager.zipItem(at: sourceURL, to: destinationURL)
        } catch {
            print("Creation of ZIP archive failed with error:\(error)")
        }
        
        return destinationURL
    }
    
    
    

    
    
    
    func getDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        let now = df.string(from: Date())
        return now
    }
    
        
    func sendRequestRequest(fileURL: URL) {
            /**
             Request
             post https://sensingkit-server.herokuapp.com/
             */

            // Add Headers
            let headers : HTTPHeaders = [
                "Content-Type":"multipart/form-data; charset=utf-8",
            ]
            
            let data = try? Data(contentsOf: fileURL)
            if data == nil {
                print("Data is not available1")
                return
            }
            
        var filename = fileURL.lastPathComponent
            
            // Fetch Request
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append("b+FRongauiv/bKy1egB8AbB2HIICNbhX5IqlbMWcfn4".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"password")
                multipartFormData.append(data!, withName :"uploadedFile", fileName: filename, mimeType: "application/zip")
                },  to: "https://sensingkit-server.herokuapp.com", method: .post, headers: headers
            ).response{response in debugPrint(response)}
        }
    
    
    func sendRequestJson(fileURL: URL) {
        /**
         Request
         post https://sensingkit-server.herokuapp.com/
         */

        // Add Headers
        let headers : HTTPHeaders = [
            "Content-Type":"multipart/form-data; charset=utf-8",
        ]
        
        let data = try? Data(contentsOf: fileURL)
        if data == nil {
            print("Data is not available2")
            return
        }
        
        print(fileURL)
        
        let jsonname = fileURL.lastPathComponent
        
        
        // Fetch Request
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("b+FRongauiv/bKy1egB8AbB2HIICNbhX5IqlbMWcfn4".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"password")
            multipartFormData.append(data!, withName :"uploadedFile", fileName: jsonname, mimeType: "application/zip")
        },  to: "https://sensingkit-server.herokuapp.com", method: .post, headers: headers
    ).response{response in debugPrint(response)}
    }

    
    

        

        
    func sendRequestVideo(fileURL: URL) {
        /**
         Request
         post https://sensingkit-server.herokuapp.com/
         */
        print(fileURL)
        // Add Headers
        let headers : HTTPHeaders = [
            "Content-Type":"multipart/form-data; charset=utf-8",
        ]

        
        //TODO: Minos please check this up: Data is read as 0 bytes. if we cancel the execution at this point the saved mp4 is 0 bytes. else, it's not.
        
        let data = try? Data(contentsOf: fileURL)
        if data == nil {
            print("Data is not available")
            return
        }
        print(data)
        
        let videoname = fileURL.lastPathComponent
        print(videoname)
     
        // Fetch Request
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("b+FRongauiv/bKy1egB8AbB2HIICNbhX5IqlbMWcfn4".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"password")
                multipartFormData.append(data!, withName :"uploadedFile", fileName: videoname, mimeType: "video/mp4")
            },  to: "https://sensingkit-server.herokuapp.com", method: .post, headers: headers
        ).response{response in debugPrint(response)}
    }

    
    
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    



}
