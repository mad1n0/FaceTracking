//
//  RegistrationConsentFormViewController.swift
//  DeepSight
//
//  Created by Kleomenis Katevas on 9/12/20.
//

import UIKit
import ResearchKit

class RegistrationConsentFormViewController: UIViewController, ORKTaskViewControllerDelegate {

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
    
    @IBAction func NextAction(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        
        // Temporary iOS 13 UI fix until ResearchKit 2.1 gets released
        //taskViewController.navigationBar.backgroundColor = .white
        
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController,
                            didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
                
        switch reason {
        case .completed:
            
            /*let signatureResult:ORKConsentSignatureResult = taskViewController.result.stepResult(forStepIdentifier: "Review")?.firstResult
            
            if signatureResult.signature?.signatureImage != nil {
                signatureResult.signature?.title = "Minos"
                //signatureResult.apply(to: <#T##ORKConsentDocument#>)
            }*/
            
            
            taskViewController.dismiss(animated: true) {
                
                // Show next screen
                self.performSegue(withIdentifier: "Registration Ready to Go", sender: self)
            }
        
        default:
            
            // dismiss
            taskViewController.dismiss(animated: true) {
                // dismiss again (Back action)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }

}
