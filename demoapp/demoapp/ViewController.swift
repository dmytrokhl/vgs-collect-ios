//
//  ViewController.swift
//  demoapp
//
//  Created by Vitalii Obertynskyi on 8/14/19.
//  Copyright © 2019 Vitalii Obertynskyi. All rights reserved.
//

import UIKit
import VGSCollectSDK

/// A class that demonstrates how to collect data from VGSTextFields and upload it to VGS
class ViewController: UIViewController {
    
    @IBOutlet weak var cardDataStackView: UIStackView!
    @IBOutlet weak var consoleStatusLabel: UILabel!
    @IBOutlet weak var consoleLabel: UILabel!

    // Init VGS Collector
    var vgsCollect = VGSCollect(id: AppCollectorConfiguration.shared.vaultId, environment: AppCollectorConfiguration.shared.environment)
    
    // VGS UI Elements
    var cardNumber = VGSCardTextField()
    var cardExpDate = VGSExpDateTextField()
    var cardCVCNumber = VGSTextField()
    var cardHolderName = VGSTextField()
    
    var consoleMessage: String = "" {
        didSet { consoleLabel.text = consoleMessage }
    }
    
    // Init CardIO Scan controller
    var scanController = VGSCardIOScanController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupElementsConfiguration()
        
        // check if device is jailbroken
        if VGSCollect.isJailbroken() {
            print("Device is Jailbroken")
        }

        // set custom headers
        vgsCollect.customHeaders = [
            "my custome header": "some custom data"
        ]

        
        // set preferred device camera
//        scanController.preferredCameraPosition = .front
        // set VGSCardIOScanDelegate
        scanController.delegate = self

        // Observing text fields
        vgsCollect.observeStates = { [weak self] form in

            self?.consoleMessage = ""
            self?.consoleStatusLabel.text = "STATE"

            form.forEach({ textField in
                self?.consoleMessage.append(textField.state.description)
                self?.consoleMessage.append("\n")
            })
        }
      
      
//      // If you need to set your own card brand icons
//
//      VGSPaymentCards.visa.brandIcon = UIImage(named: "my visa icon")
//      VGSPaymentCards.unknown.brandIcon = UIImage(named: "my unknown brand icon")
//
//      //OR
//
//        // use the closure below
//        cardNumber.cardsIconSource = { cardBrand in
//            switch cardBrand {
//            case .mastercard:
//                return UIImage(named: "bank_card")
//            case .custom(brandName: let name):
//              switch name {
//              case "Visa2":
//                return UIImage(named: "bank_card")
//              default:
//                return nil
//              }
//            default:
//                return UIImage(named: "cloud-upload")
//
//            }
//        }
//
      
    }
    
    // MARK: - Init UI
    private func setupUI() {
        
        cardDataStackView.addArrangedSubview(cardHolderName)
        cardDataStackView.addArrangedSubview(cardNumber)
        cardDataStackView.addArrangedSubview(cardExpDate)
        cardDataStackView.addArrangedSubview(cardCVCNumber)
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        consoleLabel.addGestureRecognizer(tapGesture)
        consoleLabel.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    func hideKeyboard() {
        view.endEditing(true)
        consoleLabel.endEditing(true)
    }

    private func setupElementsConfiguration() {
      
        let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card_number")
        cardConfiguration.type = .cardNumber
        cardConfiguration.isRequiredValidOnly = true
        cardNumber.configuration = cardConfiguration
        cardNumber.placeholder = "4111 1111 1111 1111"
        cardNumber.textAlignment = .natural
        cardNumber.cardIconLocation = .right
      
        // To handle VGSTextFieldDelegate methods
        // cardNumber.delegate = self
        cardNumber.becomeFirstResponder()

        let expDateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card_expirationDate")
        expDateConfiguration.isRequiredValidOnly = true
        expDateConfiguration.type = .expDate
      
        /// Default .expDate format is "##/##"
        expDateConfiguration.formatPattern = "##/####"
        
        /// Update validation rules
        expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
          VGSValidationRuleCardExpirationDate(dateFormat: .longYear, error: VGSValidationErrorType.expDate.rawValue)
        ])

        cardExpDate.configuration = expDateConfiguration
        cardExpDate.placeholder = "MM/YYYY"
        cardExpDate.monthPickerFormat = .longSymbols
        cardExpDate.keyboardAccessoryView = makeAccessoryView()
      
        let cvcConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card_cvc")
        cvcConfiguration.isRequired = true
        cvcConfiguration.type = .cvc

        cardCVCNumber.configuration = cvcConfiguration
        cardCVCNumber.isSecureTextEntry = true
        cardCVCNumber.placeholder = "CVC"
        cardCVCNumber.tintColor = .lightGray

        let holderConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "cardHolder_name")
        holderConfiguration.type = .cardHolderName
        holderConfiguration.keyboardType = .namePhonePad
      
        cardHolderName.textAlignment = .natural
        cardHolderName.configuration = holderConfiguration
        cardHolderName.placeholder = "Cardholder Name"
        
        vgsCollect.textFields.forEach { textField in
          textField.textColor = .darkText
          textField.font = .systemFont(ofSize: 22)
          textField.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
          textField.tintColor = .lightGray
          textField.delegate = self
        }
    }
    
    // Start CardIO scanning
    @IBAction func scanAction(_ sender: Any) {
        scanController.presentCardScanner(on: self, animated: true, completion: nil)
    }
    
    // Upload data from TextFields to VGS
    @IBAction func uploadAction(_ sender: Any) {
      // hide kayboard
      hideKeyboard()

      // check if textfields are valid
      vgsCollect.textFields.forEach { textField in
        textField.borderColor = textField.state.isValid ? .lightGray : .red
      }

      // send extra data
      var extraData = [String: Any]()
      extraData["customKey"] = "Custom Value"

      /// New sendRequest func
      vgsCollect.sendData(path: "/post", extraData: extraData) { [weak self](response) in
        
        self?.consoleStatusLabel.text = "RESPONSE"
        switch response {
          case .success(_, let data, _):
            if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
              self?.consoleLabel.text = (String(data: try! JSONSerialization.data(withJSONObject: jsonData["json"]!, options: .prettyPrinted), encoding: .utf8)!)
              }
              return
          case .failure(let code, _, _, let error):
            switch code {
            case 400..<499:
              // Wrong request. This also can happend when your Routs not setup yet or your <vaultId> is wrong
              self?.consoleLabel.text = "Wrong Request Error: \(code)"
            case VGSErrorType.inputDataIsNotValid.rawValue:
              if let error = error as? VGSError {
                self?.consoleLabel.text = "Input data is not valid. Details:\n \(error)"
              }
            default:
              self?.consoleLabel.text = "Something went wrong. Code: \(code)"
            }
            print("Submit request error: \(code), \(String(describing: error))")
            return
        }
      }
    }
}

extension ViewController: VGSCardIOScanControllerDelegate {
    
    //When user press Done button on CardIO screen
    func userDidFinishScan() {
        scanController.dismissCardScanner(animated: true, completion: {
            // add actions on scan controller dismiss completion
        })
    }
    
    //When user press Cancel button on CardIO screen
    func userDidCancelScan() {
        scanController.dismissCardScanner(animated: true, completion: nil)
    }
    
    //Asks VGSTextField where scanned data with type need to be set.
    func textFieldForScannedData(type: CradIODataType) -> VGSTextField? {
        switch type {
        case .expirationDateLong:
            return cardExpDate
        case .cvc:
            return cardCVCNumber
        case .cardNumber:
            return cardNumber
        default:
            return nil
        }
    }
}

extension ViewController: VGSTextFieldDelegate {
  func vgsTextFieldDidChange(_ textField: VGSTextField) {
    textField.borderColor = textField.state.isValid  ? .gray : .red
  }
}

extension ViewController {
  
  /// Accessory view for Date Picker
  func makeAccessoryView() -> UIView {
      let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
      view.backgroundColor = .darkGray
      let doneButton = UIButton(type: .system)
      doneButton.setTitle("Next", for: .normal)
      doneButton.setTitleColor(.white, for: .normal)
      doneButton.addTarget(self, action: #selector(expDateButtonAction), for: .touchUpInside)
      
      view.addSubview(doneButton)
      doneButton.translatesAutoresizingMaskIntoConstraints = false
      let views = ["button": doneButton]
      let h = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=15)-[button]-(15)-|",
                                             options: .alignAllCenterY,
                                             metrics: nil,
                                             views: views)
      NSLayoutConstraint.activate(h)
      let v = NSLayoutConstraint.constraints(withVisualFormat: "V:|[button]|",
                                             options: .alignAllCenterX,
                                             metrics: nil,
                                             views: views)
      NSLayoutConstraint.activate(v)
      return view
  }
  
  @objc func expDateButtonAction() {
      self.cardCVCNumber.becomeFirstResponder()
  }
}
