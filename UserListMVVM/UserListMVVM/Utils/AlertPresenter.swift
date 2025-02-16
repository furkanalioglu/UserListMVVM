//
//  AlertPresenter.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit

public protocol AlertPresenting {
    func showAlert(on viewController: UIViewController,
                  title: String,
                  message: String,
                  buttonTitle: String,
                  action: (() -> Void)?)
}

final class AlertPresenter: AlertPresenting {
    init() {}
    
    func showAlert(on viewController: UIViewController,
                         title: String,
                         message: String,
                         buttonTitle: String = "OK",
                         action: (() -> Void)? = nil) {
        
        DispatchQueue.main.async { [weak viewController] in
        
        let alertController = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            action?()
        }
        
        alertController.addAction(okAction)

            viewController?.present(alertController, animated: true)
        }
    }
}
