//
//  LoginVC.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/16/21.
//

import RealmSwift
import UIKit

class LoginVC: UIViewController {

    let realmService = DefaultRealmService()

    var isSignUp: Bool = false

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please enter your email"
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please enter your password"
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let signUpCheckButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()

    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up?"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let submissionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submissionButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpCheckButton)
        view.addSubview(signUpLabel)
        view.addSubview(submissionButton)

        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            signUpCheckButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            signUpCheckButton.widthAnchor.constraint(equalToConstant: 35),
            signUpCheckButton.heightAnchor.constraint(equalToConstant: 35),
            signUpCheckButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),

            signUpLabel.leadingAnchor.constraint(equalTo: signUpCheckButton.trailingAnchor, constant: 10),
            signUpLabel.centerYAnchor.constraint(equalTo: signUpCheckButton.centerYAnchor),

            submissionButton.topAnchor.constraint(equalTo: signUpCheckButton.bottomAnchor, constant: 20),
            submissionButton.widthAnchor.constraint(equalToConstant: 300),
            submissionButton.heightAnchor.constraint(equalToConstant: 50),
            submissionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc func submissionButtonTapped() {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        if isSignUp {
            realmService.signUp(with: email, password: password) { result in
                switch result {
                case .success():
                    let navigationController = UINavigationController(rootViewController: TodoListVC())
                    navigationController.navigationBar.prefersLargeTitles = true
                    UIApplication.shared.windows.first?.rootViewController = navigationController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        } else {
            realmService.login(with: email, password: password) { result in
                switch result {
                case .success():
                    let navigationController = UINavigationController(rootViewController: TodoListVC())
                    navigationController.navigationBar.prefersLargeTitles = true
                    UIApplication.shared.windows.first?.rootViewController = navigationController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    @objc func signUpButtonTapped() {
        isSignUp.toggle()
        let buttonImage = isSignUp ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        signUpCheckButton.setBackgroundImage(buttonImage, for: .normal)
    }
}

// MARK: SwiftUI Preview for UIKit

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct LoginVC_Preview: PreviewProvider {

    static var previews: some View {
        LoginVC().toPreview()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
