//
//  ViewController.swift
//  TakeMyMoney
//
//  Created by Rohit Jangid on 15/11/20.
//

import UIKit

class PaymentDataScreenViewController: UIViewController {
        
    //textfield for credit card
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var validUntilDateTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var cardHolderTextField: UITextField!
    
    @IBOutlet weak var creditCardView: UIView!
    @IBOutlet weak var payPalView: UIView!
    
    //Views of credit card
    @IBOutlet weak var cardNumberView: RoundedView!
    @IBOutlet weak var validUntilDateView: RoundedView!
    @IBOutlet weak var cvvView: RoundedView!
    @IBOutlet weak var cardHolderView: RoundedView!
    
    //paypal textField
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //views of paypal
    @IBOutlet weak var payPalEmailView: RoundedView!
    @IBOutlet weak var payPalPasswordView: RoundedView!
    
    //buttons
    @IBOutlet weak var payPalButton: RoundedButton!
    @IBOutlet weak var creditCardButton: RoundedButton!
    @IBOutlet weak var ProceedButton: RoundedButton!
    
    //Error textfield labels
    @IBOutlet weak var cardNumberError: UILabel!
    @IBOutlet weak var validYearError: UILabel!
    @IBOutlet weak var cvvError: UILabel!
    @IBOutlet weak var cardHolderNameError: UILabel!
    
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    
    var isPaymentThroughCredit: Bool = false
    
    var containError: Bool = false
    
    //to store active current active textfield
    var activeTextField: UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPayPalView()
        
        cardNumberTextField.delegate = self
        validUntilDateTextField.delegate = self
        cvvTextField.delegate = self
        cardHolderTextField.delegate = self
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        configureInitialSetup()
    }
    
    func configureInitialSetup() {
        
        cardNumberError.isHidden = true
        validYearError.isHidden = true
        cvvError.isHidden = true
        cardHolderNameError.isHidden = true
        
        emailError.isHidden = true
        passwordError.isHidden = true
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        validUntilDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentDataScreenViewController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(PaymentDataScreenViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        cardNumberTextField.addTarget(self, action: #selector(PaymentDataScreenViewController.validateCreditCardNumber(textField:)), for: .editingChanged)
        
        cvvTextField.addTarget(self, action: #selector(PaymentDataScreenViewController.validateCreditCardCvv(textField:)), for: .editingChanged)
        
        cardHolderTextField.addTarget(self, action: #selector(PaymentDataScreenViewController.validateCardHolderName(textField:)), for: .editingChanged)
        
        emailTextField.addTarget(self, action: #selector(PaymentDataScreenViewController.validatePaypalEmail(textField:)), for: .editingChanged)
        
        passwordTextField.addTarget(self, action: #selector(PaymentDataScreenViewController.validatePaypalPassword(textField:)), for: .editingChanged)
    }
    
    //Credit card textfield validation while editing
    @objc func validateCreditCardNumber(textField: UITextField) {
        validateCreditCardView(textField: textField)
        guard let string = textField.text?.components(separatedBy: .whitespaces).joined() else { return }
        var resultString: String = ""
        
        string.enumerated().forEach { (index, character) in
            if index == 16 {
                cardNumberTextField.endEditing(true)
                return
            }
            if index % 4 == 0 && index > 0 {
                resultString += " "
            }
            if index < 12 {
                resultString += "*"
            } else {
                resultString.append(character)
            }
        }
        cardNumberTextField.text = resultString
    }
    
    @objc func validateCreditCardCvv(textField: UITextField) {
        validateCreditCardView(textField: textField)
    }
    
    @objc func validateCardHolderName(textField: UITextField) {
        guard let cardHolderName = textField.text else { return }
        let name = cardHolderName.trimmingCharacters(in: .whitespaces)
        if name.count < 2 || !name.contains(" ") {
            cardHolderTextField.showError()
            cardHolderNameError.isHidden = false
            return
        }
        cardHolderNameError.isHidden = true
        cardHolderTextField.hideError()
    }
    
    //paypal textfield validation while editing
    @objc func validatePaypalEmail(textField: UITextField) {
        guard let email = textField.text else { return }
        if !isValidEmail(email) {
            emailTextField.showError()
            emailError.isHidden = false
            return
        }
        emailTextField.hideError()
        emailError.isHidden = true
    }
    
    @objc func validatePaypalPassword(textField: UITextField) {
        guard let password = textField.text else { return }
        if password.count < 5 {
            passwordTextField.showError()
            passwordError.isHidden = false
            return
        }
        passwordTextField.hideError()
        passwordError.isHidden = true
    }
    
    /// Check valid email
    /// - Parameter email: string from paypal email textfield
    /// - Returns: Bool
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    /// Loading views
    func loadPayPalView() {
        creditCardView.isHidden = true
        payPalView.isHidden = false
        payPalButton.alpha = 0.8
        creditCardButton.alpha = 1
        isPaymentThroughCredit = false
    }
    func loadCreditCardView() {
        creditCardView.isHidden = false
        payPalView.isHidden = true
        payPalButton.alpha = 1
        creditCardButton.alpha = 0.8
        isPaymentThroughCredit = true
    }
    
    /// Reseting views
    func resetCreditCardView() {
        //reset textFiled
        cardNumberTextField.endTextFieldEditing()
        validUntilDateTextField.endTextFieldEditing()
        cvvTextField.endTextFieldEditing()
        cardHolderTextField.endTextFieldEditing()
        
        cardNumberError.isHidden = true
        validYearError.isHidden = true
        cvvError.isHidden = true
        cardHolderNameError.isHidden = true
    }
    func resetPayPalView() {
        //reset textfield
        emailTextField.endTextFieldEditing()
        passwordTextField.endTextFieldEditing()
        
        emailError.isHidden = true
        passwordError.isHidden = true
    }
    
    //validation credit card textfields
    func validateCreditCardView(textField: UITextField) {
        switch textField {
        case cardNumberTextField:
            if cardNumberTextField.text!.count < 19 {
                cardNumberTextField.showError()
                cardNumberError.isHidden = false
                return
            }
            cardNumberTextField.hideError()
            cardNumberError.isHidden = true
        case validUntilDateTextField:
            if validUntilDateTextField.text!.isEmpty {
                validUntilDateTextField.showError()
                validYearError.isHidden = false
                return
            }
            validUntilDateTextField.hideError()
            validYearError.isHidden = true
        case cvvTextField:
            if cvvTextField.text!.count < 3 {
                cvvTextField.showError()
                cvvError.isHidden = false
                return
            }
            cvvTextField.endEditing(true)
            cvvError.isHidden = true
            cvvTextField.hideError()
        case cardHolderTextField:
            validateCardHolderName(textField: cardHolderTextField)
        default:
            print("hideError triggered")
            textField.hideError()
        }
    }
    
    //validation paypal textfield
    func validatePaypalView(textField: UITextField) {
        switch textField {
        case emailTextField:
            validatePaypalEmail(textField: textField)
        case passwordTextField:
            validatePaypalPassword(textField: textField)
        default:
            print("hideError triggered")
            textField.hideError()
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func tapDone() {
        if let datePicker = self.validUntilDateTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            self.validUntilDateTextField.text = dateformatter.string(from: datePicker.date) //2-4
        }
        validateCreditCardView(textField: validUntilDateTextField)
        self.validUntilDateTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        var shouldMoveViewUp = false
        
        //to check if the textfield is below keyboard
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        // move the root view up by the distance of keyboard height
        if shouldMoveViewUp {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
    func checkTextField() -> Bool {
        
        let creditTextFields = [cardNumberError, validYearError, cvvError, cardHolderNameError]
        let paypalTextFields = [emailError, passwordError]
        var textFields: [UILabel?]
        
        if isPaymentThroughCredit == true {
            textFields = creditTextFields
        } else {
            textFields = paypalTextFields
        }
        
        for textField in textFields {
            if textField!.isHidden == false {
                return false
            }
        }
        return true
    }

    @IBAction func PayPalPaymentTapped(_ sender: RoundedButton) {
        loadPayPalView()
        resetCreditCardView()
    }
    
    @IBAction func CreditPaymentTapped(_ sender: RoundedButton) {
        loadCreditCardView()
        resetPayPalView()
    }
    
    @IBAction func ProceedToPayTapped(_ sender: RoundedButton) {
        if isPaymentThroughCredit {
            let creditTextFields = [cardNumberTextField, validUntilDateTextField, cvvTextField, cardHolderTextField]
            
            for creditTextField in creditTextFields {
                if let textField = creditTextField {
                    validateCreditCardView(textField: textField)
                }
            }
            print("Credit Card")
        } else {
            let paypalTextfields = [emailTextField, passwordTextField]
            
            for paypaltextField in paypalTextfields {
                if let textField = paypaltextField {
                    validatePaypalView(textField: textField)
                }
            }
            print("PayPal")
        }
//        performSegue(withIdentifier: "paymentScreen", sender: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "paymentScreen" && checkTextField() == true {
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PaymentViewController {
            if isPaymentThroughCredit {
                destinationVC.creditCard = cardNumberTextField.text
            } else {
                destinationVC.paypal = emailTextField.text
            }
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {}
    
}

//MARK: - UITextFieldDelegate
extension PaymentDataScreenViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case cardHolderTextField:
            // Length be 18 characters max and 3 characters minimum, you can always modify.
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let Regex = "[a-z A-Z]+"
            let predicate = NSPredicate.init(format: "SELF MATCHES %@", Regex)
            if predicate.evaluate(with: text) || string == "" {
                return true
            }
            else {
                return false
            }
        default:
//            print("default case")
            return true
        }
    }
}
