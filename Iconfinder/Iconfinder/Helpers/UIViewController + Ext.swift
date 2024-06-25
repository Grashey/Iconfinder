//
//  UIViewController + Ext.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//

import UIKit

extension UIViewController {
    
    func showToast(message : String, success: Bool) {
        let backgroundColor: UIColor = success ? .green :  .red
        let label = UILabel(frame: CGRect(x: 30, y: view.frame.size.height - 150, width: view.frame.size.width - 60, height: 35))
        label.backgroundColor = backgroundColor.withAlphaComponent(0.7)
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center;
        label.text = message
        label.alpha = 1.0
        label.layer.cornerRadius = 10;
        label.clipsToBounds  =  true
        view.addSubview(label)
        UIView.animate(withDuration: 1.0, delay: 1, options: .curveEaseOut, animations: {
            label.transform = CGAffineTransform(translationX: 0, y: 150)
        }, completion: {(isCompleted) in
            label.removeFromSuperview()
        })
    }
}
