//
//  NoteViewController.swift
//  Taskflow
//
//  Created by Kanchan Bandesha on 3/14/25.
//

import UIKit

class NoteViewController: UIViewController {
    
    var noteText: String?
    var onSave: ((String) -> Void)?
    
    private let textView: UITextView = {
         let tv = UITextView()
         tv.font = UIFont.systemFont(ofSize: 16)
         tv.translatesAutoresizingMaskIntoConstraints = false
         return tv
    }()
    
    private let cancelButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("✕", for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
    }()
    
    private let saveButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("✓", for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
    }()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        view.backgroundColor = .systemBackground
         
         view.addSubview(textView)
         view.addSubview(cancelButton)
         view.addSubview(saveButton)
         
         textView.text = noteText
         
         cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
         saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
         
         setupConstraints()
    }
    
    private func setupConstraints() {
         let safeArea = view.safeAreaLayoutGuide
         NSLayoutConstraint.activate([
             textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
             textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
             textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
             textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60),
             
             cancelButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
             cancelButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
             
             saveButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
             saveButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
         ])
    }
    
    @objc private func cancelTapped() {
         dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveTapped() {
         onSave?(textView.text)
         dismiss(animated: true, completion: nil)
    }
}
