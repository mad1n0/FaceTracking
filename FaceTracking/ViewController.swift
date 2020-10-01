//
//  ViewController.swift
//  FaceTracking
//
//  Created by Marc Valdivieso Merino on 22/09/2020.
//

import UIKit
import SensingKit

class ViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.fTSensingSession.enableSensor(sensorType: SKSensorType.Location)
    }


    
    @IBAction func startAction(_ sender: UIButton) {
        print("Button says hi")
        
        
    }
    
    @IBAction func StartSensing(_ sender: Any) {
        
        
        if(appDelegate.fTSensingSession.isSensorAvailable(sensorType: SKSensorType.Location))
        {
            print("Location enabled")
        }
        
        if appDelegate.fTSensingSession.start(sensorType:  SKSensorType.Location){
            print("cont enabled")
        }

        
        
        
    }
}


