//
//  NoteListViewController.swift
//  test19
//
//  Created by Lika Nozadze on 11/5/23.
//

import UIKit

final class NoteListViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tableView.layer.shadowRadius = 2
        return tableView
    }()
    
    private var notesData = [String]()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupTableView()
        setupNavigationBar()
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func setupBackground() {
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        self.title = "Note List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapPlusButton))
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.identifier)
    }
    
    
    @objc private func didTapPlusButton() {
        let addNoteViewController = AddNoteViewController()
        addNoteViewController.delegate = self
        navigationController?.pushViewController(addNoteViewController, animated: true)
    }
}

// MARK: - TableView DataSource
extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        cell.configure(with: notesData[indexPath.row])
        return cell
    }
    // MARK: - Deleterow
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notesData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


// MARK: - TableView Delegate
extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let noteDetailsVC = NoteDetailsViewController()
        noteDetailsVC.note = notesData[indexPath.row]
        noteDetailsVC.noteIndex = indexPath.row
        noteDetailsVC.delegate = self
        navigationController?.pushViewController(noteDetailsVC, animated: true)
    }
}

// MARK: - AddNoteDelegate
extension NoteListViewController: AddNoteDelegate {
    func addNewNote(_ note: String) {
        notesData.append(note)
        tableView.reloadData()
    }
}

extension NoteListViewController: NoteDetailsDelegate {
    func updateNote(_ note: String?, at index: Int) {
        if let note = note, index >= 0, index < notesData.count {
            notesData[index] = note
            tableView.reloadData()
        }
    }
    
}
