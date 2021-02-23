//
//  CommsManager.swift
//  DeepSight
//
//  Created by Marc Valdivieso Merino on 09/12/2020.
//

import Foundation
import Alamofire

class CommsManager {
    
    let sendingQueue = DispatchQueue(label: "sendingQueue", qos: .utility, attributes: .concurrent)
    var urls : [URL] = []
    var senturls : [URL] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(){
        
        

    }
    
    
    
    func addElement (elementURL : URL){
        urls.append(elementURL)
        
    }
    
    
    
    func sendElement (elementURL: URL){
        
        sendRequest(fileURL: elementURL)
        senturls.append(elementURL)
    
    }
    
    
    
    func sendFiles(){
        
        for url in urls{
            sendElement(elementURL:url)
            
        }
        urls.removeAll()
        
    }
    
    
    
    func printURLS(){
        
        for url in senturls{
            print(url)
        }
        
    }
    
    
    
    func sendRequest2(fileURL: URL) {
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
            print("Data is not available")
            return
        }
        

        let filename = fileURL.lastPathComponent
        
        let urlExtension : String? = fileURL.pathExtension
        
        // Fetch Request
        
        if (urlExtension == "mp4"){
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append("b+FRongauiv/bKy1egB8AbB2HIICNbhX5IqlbMWcfn4".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"password")
                    multipartFormData.append(data!, withName :"uploadedFile", fileName: filename, mimeType: "video/mp4")
                },  to: "https://sensingkit-server.herokuapp.com", method: .post, headers: headers
            ).response{response in debugPrint(response)}
        }
        
        else if (urlExtension == "zip"){
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append("b+FRongauiv/bKy1egB8AbB2HIICNbhX5IqlbMWcfn4".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"password")
                multipartFormData.append(data!, withName :"uploadedFile", fileName: filename, mimeType: "application/zip")
            },  to: "https://sensingkit-server.herokuapp.com", method: .post, headers: headers
        ).response{response in debugPrint(response)}
            
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    func sendRequest(fileURL: URL) {
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
            print("Data is not available")
            return
        }
        

        let filename = fileURL.lastPathComponent
        
        let urlExtension : String? = fileURL.pathExtension
        
        // Fetch Request
        
        if (urlExtension == "mp4"){
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append("b+FRongauiv/bKy1egB8AbB2HIICNbhX5IqlbMWcfn4".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"password")
                    multipartFormData.append(data!, withName :"uploadedFile", fileName: filename, mimeType: "video/mp4")
                },  to: "tidpublic.duckdns.org", method: .post, headers: headers
            ).response{response in debugPrint(response)}
        }
        
        else if (urlExtension == "zip"){
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append("b+FRongauiv/bKy1egB8AbB2HIICNbhX5IqlbMWcfn4".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"password")
                multipartFormData.append(data!, withName :"uploadedFile", fileName: filename, mimeType: "application/zip")
            },  to: "tidpublic.duckdns.org", method: .post, headers: headers
        ).response{response in debugPrint(response)}
            
        }
    }
    
    
    



}
