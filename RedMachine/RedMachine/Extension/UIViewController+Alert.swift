//
//  UIViewController+Alert.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/23.
//

import UIKit

extension UIViewController {
    
    /// Show AlertController with message
    ///
    /// - Parameter message: message to show.
    /// - Returns: Void.
    
    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Warning",
            message: message,
            preferredStyle: .alert
        )

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }
}
