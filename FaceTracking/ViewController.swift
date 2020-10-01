//
//  ViewController.swift
//  FaceTracking
//
//  Created by Marc Valdivieso Merino on 22/09/2020.
//

import UIKit
import SensingKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ce")
        cell.textLabel?.text = list[indexPath.row]
        return cell
        
    }
    
//    func pressed
    
    @IBAction func changeColor(sender: UIButton) {
        print(sender.classForCoder)
        print(sender.superclass)
         
        let r = CGFloat(arc4random() % 255)
        let g = CGFloat(arc4random() % 255)
        let b = CGFloat(arc4random() % 255)
         
        let color = UIColor(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: 1.0)
         
        view.backgroundColor = color
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        print("Button says hi")
        
        
    }
    
    @IBAction func StartSensing(_ sender: Any) {
        
        appDelegate.fTSensingSession.enableSensor(sensorType: SKSensorType.Location)
        if(appDelegate.fTSensingSession.isSensorAvailable(sensorType: SKSensorType.Location))
        {
            print("Location enabled")
        }
        
        if appDelegate.fTSensingSession.start(sensorType:  SKSensorType.Location){
            print("cont enabled")
        }

        
        
        
    }
}


