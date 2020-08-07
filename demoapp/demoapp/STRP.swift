//
//  STRP.swift
//  demoapp
//
//  Created by Dima on 06.08.2020.
//  Copyright © 2020 Very Good Security. All rights reserved.
//


import UIKit
import Stripe

let backendUrl = "http://127.0.0.1:4242/"
class STRP: UIViewController {
  
  var paymentIntentClientSecret: String?
  lazy var cardTextField: STPPaymentCardTextField = {
    let cardTextField = STPPaymentCardTextField()
    
    return cardTextField
  }()
  
  lazy var payButton: UIButton = {
    let button = UIButton(type: .custom)
    button.layer.cornerRadius = 5
    button.backgroundColor = .systemBlue
    button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
    button.setTitle("Pay now", for: .normal)
    button.addTarget(self, action: #selector(pay), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    Stripe.setDefaultPublishableKey("pk_test_TYooMQauvdEDq54NiTphI7jx")
    view.backgroundColor = .white
    cardTextField.delegate = self
    let stackView = UIStackView(arrangedSubviews: [cardTextField, payButton])
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
      view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
      stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
    ])
    startCheckout()
  }
  
  func displayAlert(title: String, message: String, restartDemo: Bool = false) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel))
      self.present(alert, animated: true, completion: nil)
    }
  }

  func startCheckout() {
    // Create a PaymentIntent as soon as the view loads
    let url = URL(string: backendUrl + "create-payment-intent")!
    let json: [String: Any] = [
      "items": [
          ["id": "xl-shirt"]
      ]
    ]
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: json)
    let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
      guard let response = response as? HTTPURLResponse,
        response.statusCode == 200,
        let data = data,
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
        let clientSecret = json["clientSecret"] as? String else {
            let message = error?.localizedDescription ?? "Failed to decode response from server."
            self?.displayAlert(title: "Error loading page", message: message)
            return
      }
      print("Created PaymentIntent")
      self?.paymentIntentClientSecret = clientSecret
    })
    task.resume()
  }
  
  @objc
   func pay() {
      
     guard let paymentIntentClientSecret = paymentIntentClientSecret else {
         return;
     }
     // Collect card details
     let cardParams = cardTextField.cardParams
      if cardTextField.isValid {
        print(true)
      } else {
        
      }
     let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
     let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
     paymentIntentParams.paymentMethodParams = paymentMethodParams
     // Submit the payment
     let paymentHandler = STPPaymentHandler.shared()
     paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
       switch (status) {
       case .failed:
           self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
           break
       case .canceled:
           self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
           break
       case .succeeded:
           self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "")
           break
       @unknown default:
           fatalError()
           break
       }
     }
   }
}

extension STRP: STPAuthenticationContext {
  func authenticationPresentingViewController() -> UIViewController {
      return self
  }
}

extension STRP: STPPaymentCardTextFieldDelegate {
  
}
