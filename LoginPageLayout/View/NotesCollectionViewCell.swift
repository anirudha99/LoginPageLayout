//
//  NotesCollectionViewCell.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 27/10/21.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    let noteTitleLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .darkGray
        label.textColor = .yellow
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Sample text for title"
        return label
    }()
    
//    let noteLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.text = "Sample text for note"
//        return label
//    }()
    
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
//        delbtn.backgroundColor = UIColor.black
//        delbtn.setTitle("Delete", for: UIControl.State.normal)
        delbtn.setImage(UIImage(systemName: "xmark.bin"), for: UIControl.State.normal)
        return delbtn
    }()
    
//    var listViewButton: UIButton = {
//        let listViewBtn = UIButton()
//        listViewBtn.backgroundColor = UIColor.white
//        listViewBtn.setImage(UIImage(systemName: "list.bullet"), for: UIControl.State.normal)
//        return listViewBtn
//    }()
  
    
   
    //MARK: - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = .darkGray
        
        configure()
        
//        addSubview(noteTitleLabel)
//        noteTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        noteTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//
//        addSubview(noteLabel)
//        noteLabel.translatesAutoresizingMaskIntoConstraints = false
//        noteLabel.centerYAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    //MARK: - Handlers
    
    func configure(){
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        addSubview(noteTitleLabel)
        noteTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noteDeleteButton)
        noteDeleteButton.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(listViewButton)
//        listViewButton.translatesAutoresizingMaskIntoConstraints = false
        
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
           
          
//            listViewButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            listViewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
//            listViewButton.heightAnchor.constraint(equalToConstant: 15),
//            listViewButton.widthAnchor.constraint(equalToConstant: 15),
//            listViewButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
//            listViewButton.centerYAnchor.constraint(equalTo: centerYAnchor)

            
        ])
    }

}

//------------------------------







