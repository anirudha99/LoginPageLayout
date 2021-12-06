//
//  NotesCollectionViewCell.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 27/10/21.
//
import Foundation
import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var activityIndicator: UIActivityIndicatorView!
    
    let noteTitleLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .darkGray
        label.textColor = .yellow
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Sample text for title"
        return label
    }()
    
    var noteLabel:  UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 18)
        label.backgroundColor = .gray
        label.isScrollEnabled = false
        label.isEditable = false
        return label
    }()
    
    var noteDeleteButton: UIButton = {
        let delbtn = UIButton()
        delbtn.setImage(UIImage(systemName: "xmark.bin"), for: UIControl.State.normal)
        return delbtn
    }()
    
    var noteArchiveButton: UIButton = {
        let archivebtn = UIButton()
        archivebtn.setImage(UIImage(systemName: "archivebox.fill"), for: UIControl.State.normal)
        return archivebtn
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    //MARK: - Handlers
    
    private func configure(){
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        addSubview(noteTitleLabel)
        noteTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noteDeleteButton)
        noteDeleteButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noteArchiveButton)
        noteArchiveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            noteTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            noteTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            noteTitleLabel.heightAnchor.constraint(equalToConstant: 100),
            
            noteLabel.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 10),
            noteLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            noteLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            noteLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            noteDeleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            noteDeleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            noteDeleteButton.heightAnchor.constraint(equalToConstant: 15),
            noteDeleteButton.widthAnchor.constraint(equalToConstant: 15),
            
            noteArchiveButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            noteArchiveButton.rightAnchor.constraint(equalTo: noteDeleteButton.leftAnchor, constant: -10),
            noteArchiveButton.heightAnchor.constraint(equalToConstant: 15),
            noteArchiveButton.widthAnchor.constraint(equalToConstant: 15),
            
        ])
    }
}







