//
//  RoundedButton.swift
//  TakeMyMoney
//
//  Created by Rohit Jangid on 17/11/20.
//

import UIKit

class RoundedButton: UIButton {

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        clipsToBounds = true
    }

}
