//
//  File.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/3/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let primaryColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
}

class LoginViewController : UIViewController {
    
    let logView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
        
    }()
    let email: UITextField =  {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Email"
        return textfield
    }()
    
    let password: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Password"
        textfield.isSecureTextEntry = true
        return textfield
    }()
    lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .primaryColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var signupButton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.primaryColor, for: .normal)
        button.addTarget(self, action: #selector(goToSignupPage), for: .touchUpInside)
        return button
    }()
    
    @objc func goToSignupPage(){
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        
        setupLoginPage()
        
        
    }
    
    private func setupLoginPage(){
        view.addSubview(logView)
        view.addSubview(email)
        view.addSubview(password)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        let constraints = [
            
            logView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160),
            logView.widthAnchor.constraint(equalToConstant: 100),
            logView.heightAnchor.constraint(equalToConstant: 100),
            
            
            email.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            email.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-50),
            email.heightAnchor.constraint(equalToConstant: 30),
            email.widthAnchor.constraint(equalToConstant: 250),
            password.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            password.centerYAnchor.constraint(equalTo: email.centerYAnchor, constant: 50),
            password.heightAnchor.constraint(equalToConstant: 30),
            password.widthAnchor.constraint(equalToConstant: 250),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: password.centerYAnchor, constant: 70),
            loginButton.heightAnchor.constraint(equalToConstant: 30),
            loginButton.widthAnchor.constraint(equalToConstant:  70),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            signupButton.heightAnchor.constraint(equalToConstant: 30),
            signupButton.widthAnchor.constraint(equalToConstant:  70),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
}


extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewDict = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDict[key] = view
            
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewDict))
    }
}
