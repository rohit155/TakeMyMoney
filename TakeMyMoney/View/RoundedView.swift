//
//  RoundedView.swift
//  TakeMyMoney
//
//  Created by Rohit Jangid on 20/11/20.
//

import UIKit

class RoundedView: UIView {

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
