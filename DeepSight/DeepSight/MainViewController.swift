//
//  MainViewController.swift
//  DeepSight
//
//  Created by Kleomenis Katevas on 4/12/20.
//

import UIKit

class MainViewController: UIViewController {
    
    var registered = false;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (registered == false) {
            // Show registration screen
            self.performSegue(withIdentifier: "Show Registration Screen", sender: self)
            registered = true
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Make destination appear Full Screen
        segue.destination.modalPresentationStyle = .fullScreen
    }
    
    @IBAction func startTaskX(_ sender: Any) {
        self.performSegue(withIdentifier: "Start Task", sender: self)
    }
    
}
