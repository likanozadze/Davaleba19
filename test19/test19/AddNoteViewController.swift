//
//  AddNoteViewController.swift
//  test19
//
//  Created by Lika Nozadze on 11/5/23.
//

import UIKit

protocol AddNoteDelegate: AnyObject {
    func addNewNote(_ note: String)
}

final class AddNoteViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: AddNoteDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Note"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your note"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save Note", for: .normal)
        button.backgroundColor = UIColor(red: 34/255, green: 87/255, blue: 122/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
        
    }()
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
        setupActions()
    }
    
    private func setupSubviews() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(noteTextField)
        containerView.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            noteTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            noteTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            noteTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            saveButton.topAnchor.constraint(equalTo: noteTextField.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
    }
    
    
    
    @objc private func saveNote() {
        guard let noteText = noteTextField.text, !noteText.isEmpty else {
            
            return
        }
        delegate?.addNewNote(noteText)
        navigationController?.popViewController(animated: true)
    }
}
