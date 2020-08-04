//
//  SignUpViewController.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/3/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    lazy var profileImage : UIImageView  = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "placeholder")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadPhoto(_:))))
        return imageView
    }()
    let selectLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select Profile Picture"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    @objc func uploadPhoto (_ sender: UITapGestureRecognizer){
        email.resignFirstResponder()
        password.resignFirstResponder()

        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage]  as? UIImage{
        profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
        
        
    }

    let email: UITextField =  {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Email"
        return textfield
    }()
    
    let firstName: UITextField =  {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "First Name"
        return textfield
    }()
    let LastName: UITextField =  {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Last Name"
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
    
    let confirmPassword: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Confirm Password"
        textfield.isSecureTextEntry = true
        return textfield
    }()
    lazy var signupButton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .primaryColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        return button
    }()
    
    @objc func createAccount(){
        
        
        if firstName.text == "" || LastName.text == "" {
            let  alertTitle = "Incomplete Credentials"
            var alertMessage = ""
            if firstName.text == "" && LastName.text != "" {
                alertMessage = "Please enter your first name"
                
            }
            else if  firstName.text != "" && LastName.text == ""{

                alertMessage = "Please enter your last name"
                
            }
            else{
                alertMessage = "Please enter your first and last name"
            }
            let alertController = UIAlertController(title: alertTitle , message:  alertMessage, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        else if password.text != confirmPassword.text{
            let alertController = UIAlertController(title: "Password Misatched" , message: "Please veriy your passwords", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        else {
        let progressWindow = ProgressWindow()
        progressWindow.label = "Creating Your Account"
        progressWindow.showProgress()
        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: {
            
            (auth, err) in
            progressWindow.dissmisProgress()
            if err != nil {
                let attributedString = NSAttributedString(string: "Sign Up Failed !", attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.red
                ])
                let alertController = UIAlertController(title: "" , message:                err!.localizedDescription, preferredStyle: .alert)
                alertController.setValue(attributedString, forKey: "attributedTitle")
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.email.text = ""
                    self.password.text = ""
                    self.confirmPassword.text = ""
                    self.firstName.text = ""
                    self.LastName.text = ""
                }))
                self.present(alertController, animated: true, completion: nil)
            }else{
                
                let storageRef = Storage.storage().reference()
                let userImageRef = storageRef.child("image/\(auth!.user.uid).png")
                
                if let data = self.profileImage.image!.pngData() {
                    
                    userImageRef.putData(data, metadata: nil){
                        (metadata ,error) in
                        guard let metadata = metadata else {
                           return
                         }
                        if error != nil {
                            
                            
                            let attributedString = NSAttributedString(string: "Can Not upload Profile Image !", attributes: [
                                NSAttributedString.Key.foregroundColor : UIColor.red
                            ])
                            let alertController = UIAlertController(title: "" , message:                err!.localizedDescription, preferredStyle: .alert)
                            alertController.setValue(attributedString, forKey: "attributedTitle")
                            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                                
                                self.profileImage.image = UIImage(named: "placeholder")
                            }))
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                    }
                }
                
                let db = Firestore.firestore()
                db.collection("users").document("\(auth!.user.uid)") .setData(
                    
                    [
                        "email": self.email.text!,
                        "firstName":  self.firstName.text!,
                        "lastName": self.LastName.text!
                    
                    ]
                    ){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    }
                }
                
                
                auth?.user.sendEmailVerification(completion: {
                    (result) in
                    let alertController = UIAlertController(title: "Verification Email Sent" , message: "Please verify your email account to log in", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style:.default, handler:  { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                })
                
                
                
            }
            
            
        })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryColor]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Create Your Account"
        navigationController?.navigationBar.titleTextAttributes  = [NSAttributedString.Key.foregroundColor:UIColor.primaryColor]
        navigationController?.navigationBar.tintColor =  .primaryColor
        setupSignUpPage()
    }
    
    private func setupSignUpPage(){
        view.addSubview(profileImage)
        view.addSubview(selectLabel)
        view.addSubview(email)
        view.addSubview(firstName)
        view.addSubview(LastName)
        view.addSubview(password)
        view.addSubview(confirmPassword)
        view.addSubview(signupButton)
        let constraints = [
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  100),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor),
            
            selectLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectLabel.centerYAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15),
            
            email.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            email.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-50),
            email.heightAnchor.constraint(equalToConstant: 30),
            email.widthAnchor.constraint(equalToConstant: 250),
            
            firstName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstName.centerYAnchor.constraint(equalTo: email.centerYAnchor, constant:50),
            firstName.heightAnchor.constraint(equalToConstant: 30),
            firstName.widthAnchor.constraint(equalToConstant: 250),
            
            
            LastName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            LastName.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:50),
            LastName.heightAnchor.constraint(equalToConstant: 30),
            LastName.widthAnchor.constraint(equalToConstant: 250),
            
            password.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            password.centerYAnchor.constraint(equalTo: LastName.centerYAnchor, constant: 50),
            password.heightAnchor.constraint(equalToConstant: 30),
            password.widthAnchor.constraint(equalToConstant: 250),
            
            confirmPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPassword.centerYAnchor.constraint(equalTo: password.centerYAnchor, constant: 50),
            confirmPassword.heightAnchor.constraint(equalToConstant: 30),
            confirmPassword.widthAnchor.constraint(equalToConstant: 250),
            
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.centerYAnchor.constraint(equalTo: confirmPassword.centerYAnchor, constant: 70),
            signupButton.heightAnchor.constraint(equalToConstant: 30),
            signupButton.widthAnchor.constraint(equalToConstant:  90)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
     // toDo : validate input
    }
    
}
