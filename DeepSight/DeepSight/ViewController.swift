//
//  ViewController.swift
//  FaceTracking
//
//  Created by Marc Valdivieso Merino on 22/09/2020.
//

import UIKit
import SensingKit
import AVFoundation
import Photos
import AVKit
import MobileCoreServices
import ARKit
import SSZipArchive


class ViewController: UIViewController {
    

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: Properties

    var contentControllers: [VirtualContentType: VirtualContentController] = [:]
    
    
    private var backgroundRecordingID: UIBackgroundTaskIdentifier?
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    
    //@IBOutlet private weak var previewView: PreviewView!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


        @IBAction func StartSensing(_ sender: Any) {
            
            //let z = Zipper()
            let fileManager = FileManager()
            let currentWorkingPath = getDocumentsDirectory()
            var sourceURL = URL(fileURLWithPath: currentWorkingPath.absoluteString)
            
            sourceURL.appendPathComponent("malaka.json")
            var destinationURL = URL(fileURLWithPath: currentWorkingPath.absoluteString)
            destinationURL.appendPathComponent("archive.zip")
            do {
                try fileManager.zipItem(at: sourceURL, to: destinationURL)
            } catch {
                print("Creation of ZIP archive failed with error:\(error)")
            }
            

        }
    
    

    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    

    
    @IBAction func startAR(_ sender: Any) {
        
 
        
    }

    
    
        
        
        
    @IBAction func stopSensing(_ sender: Any) {

        
    }
    
    
    
    
    
    
 
        



}
