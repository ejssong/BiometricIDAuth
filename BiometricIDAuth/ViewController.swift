//
//  ViewController.swift
//  BiometricIDAuth
//
//  Created by ejsong on 6/3/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let biometricIDAuth = BiometricIDAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapAuth(_ sender: Any) {
        biometricIDAuth.canEvaluate { [weak self] (canEvaluate, canEvaluateError) in
            guard canEvaluate else {
                self?.alert(title: "Error",
                      message: canEvaluateError?.localizedDescription ?? "Face ID/Touch ID may not be configured")
                return
            }
            
            
            self?.biometricIDAuth.evaluate { [weak self] (success, error) in
                guard success else {
                    self?.alert(title: "Error",
                                message: error?.localizedDescription ?? "Face ID/Touch ID may not be configured")
                    return
                }
                
                self?.alert(title: "Success",
                            message: "You've passed")
            }
            
        }
    }
    
    func alert(title: String, message: String, confirmTitle: String = "confirm") {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: confirmTitle, style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
    
}

