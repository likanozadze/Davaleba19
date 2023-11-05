//
//  NoteDetailsViewController.swift
//  test19
//
//  Created by Lika Nozadze on 11/5/23.
//

import UIKit

protocol NoteDetailsDelegate: AnyObject {
    func updateNote(_ note: String?, at index: Int)
}

final class NoteDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var note: String?
    var noteIndex: Int?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 35, left: 52, bottom: 35, right: 52)
        return stackView
    }()
    
    private let noteTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 34/255, green: 87/255, blue: 122/255, alpha: 1.0)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 34/255, green: 87/255, blue: 122/255, alpha: 1.0)
        return button
    }()
    
    
    weak var delegate: NoteDetailsDelegate?
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addMainSubviews()
        setupConstraints()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        title = "Note Details"
        
        // Configure editButton
        editButton.addTarget(self, action: #selector(editNote), for: .touchUpInside)
        editButton.isHidden = note == nil || note?.isEmpty == true
        
        // Configure saveButton
        saveButton.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
        saveButton.isHidden = true
    }
    func addMainSubviews() {
        
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(noteTextField)
        mainStackView.addArrangedSubview(editButton)
        mainStackView.addArrangedSubview(saveButton)
        
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            noteTextField.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        
        noteTextField.text = note
    }
    
    @objc private func editNote() {
        noteTextField.isUserInteractionEnabled = true
        noteTextField.becomeFirstResponder()
        editButton.isHidden = true
        saveButton.isHidden = false
    }
    
    @objc private func saveNote() {
        noteTextField.isUserInteractionEnabled = false
        noteTextField.resignFirstResponder()
        note = noteTextField.text
        editButton.isHidden = false
        saveButton.isHidden = true
        if let noteIndex = noteIndex, noteIndex >= 0 {
            delegate?.updateNote(note, at: noteIndex)
        }
    }
}



