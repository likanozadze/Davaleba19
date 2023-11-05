//
//  LoginViewController.swift
//  test19
//
//  Created by Lika Nozadze on 11/5/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 35, left: 52, bottom: 35, right: 52)
        return stackView
    }()
    
    private let notesLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.frame = CGRect(x: 0, y: 0, width: 289, height: 53)
        
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.frame = CGRect(x: 0, y: 0, width: 289, height: 53)
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(red: 34/255, green: 87/255, blue: 122/255, alpha: 1.0)
        return button
        
    }()
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getPassword()
        
        func getPassword() {
            guard let data = KeychainManager.get(
                service: "NoteApp",
                account: "Lika"
            ) else {
                print("Failed to read password")
                return
            }
            let password = String(decoding: data, as: UTF8.self)
            print("Read password: \(password)")
            
            if UserDefaultsManager.isFirstTimeLogin() {
                showWelcomeAlert()
                
                UserDefaultsManager.setFirstTimeLogin(false)
            } else {
                print("Welcome back!")
            }
        }
        
        
        func save() {
            
            do {
                try KeychainManager.save(
                    service: "NoteApp",
                    account: "Lika",
                    password: "Something".data(using: .utf8) ?? Data()
                )
                
            }
            catch {
                print(error)
            }
        }
        
        
        setupUI()
        
        func showWelcomeAlert() {
            let alert = UIAlertController(title: "", message: "Welcome 🤘🏻", preferredStyle: .alert)
            
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addMainSubviews()
        setupConstraints()
    }
    
    private func addMainSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(notesLabel)
        mainStackView.addArrangedSubview(usernameTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(signInButton)
        
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ])
        
        signInButton.addTarget(self, action: #selector(goToNextScreen), for: .touchUpInside)
    }
    
    @objc func goToNextScreen() {
        let nextScreen = NoteListViewController()
        nextScreen.title = "Note List"
        navigationController?.pushViewController(nextScreen, animated: true)
    }
}

class KeychainManager {
    enum KeyChainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    static func save(
        service: String,
        account: String,
        password: Data
    ) throws {
        
        //service, account, password, class,
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject,
            
        ]
        
        let status =  SecItemAdd(
            query as CFDictionary,
            nil
        )
        guard status != errSecDuplicateItem else {
            throw KeyChainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeyChainError.unknown(status)
        }
        print("saved")
    }
    
    
    static func get(
        service: String,
        account: String
        
    ) -> Data? {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
            
        ]
        
        var result: AnyObject?
        let status =  SecItemCopyMatching(
            query as CFDictionary,
            &result
        )
        print("read status: \(status)")
        return result as? Data
    }
}
