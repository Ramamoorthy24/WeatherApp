//
//  ViewController + Extension.swift
//  WashDryGoEndUser
//
//  Created by vino mac mini on 4/9/20.
//  Copyright © 2020 vino mac mini. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String, title: String = AppName) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            })
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithOptions(title: String = AppName, message: String, options: String..., completion: @escaping (Int) -> Void) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for (index, option) in options.enumerated() {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    completion(index)
                }))
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
   
    
}
