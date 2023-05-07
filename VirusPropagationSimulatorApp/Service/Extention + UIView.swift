//
//  Extention + UIView.swift
//  VirusPropagationSimulatorApp
//
//  Created by Илья Дубенский on 04.05.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }
}
