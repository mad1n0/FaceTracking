//
//  RegistrationReadyToGoViewController.swift
//  DeepSight
//
//  Created by Kleomenis Katevas on 9/12/20.
//

import UIKit

class RegistrationReadyToGoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func FinishAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
