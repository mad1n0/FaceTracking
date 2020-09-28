//
//  ViewController.swift
//  FaceTracking
//
//  Created by Marc Valdivieso Merino on 22/09/2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let rect = CGRect(x: 10, y: 10, width: 100, height: 100)
    let list = ["un","dos","tres","quatre"]
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hola")
        // Do any additional setup after loading the view.
        let myView  = UIView(frame: rect)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ce")
        cell.textLabel?.text = list[indexPath.row]
        return cell
        
    }
    
    
    @IBAction func changeColor(sender: UIButton) {
        print(sender.classForCoder)
        print(sender.superclass)
         
        let r = CGFloat(arc4random() % 255)
        let g = CGFloat(arc4random() % 255)
        let b = CGFloat(arc4random() % 255)
         
        let color = UIColor(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: 1.0)
         
        view.backgroundColor = color
    }

}


