//
//  PaymentViewController.swift
//  TakeMyMoney
//
//  Created by Rohit Jangid on 24/12/20.
//

import UIKit

class PaymentViewController: UIViewController {
    
    var creditCard: String?
    var paypal: String?

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var paymentTitle: UILabel!
    @IBOutlet weak var paymentDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI() {
        if let credit = creditCard {
            logo.image = UIImage(named: "mastercard")
            paymentTitle.text = "Card Holder"
            paymentDetail.text = "Master Card ending \(String(credit.suffix(4)))"
        }
        if let paypalInfo = paypal {
            logo.image = UIImage(named: "paypal")
            paymentTitle.text = "Paypal"
            paymentDetail.text = "\(paypalInfo)"
        }
    }

    @IBAction func payButtonTapped(_ sender: RoundedButton) {
        let alertVC = UIAlertController(title: "Opps! Sorry", message: "There was problem while processing the payment please try again later.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        alertVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertVC, animated: true, completion: nil)
    }
    
}
