//
//  NotificationController.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 27/10/21.
//

import UIKit

private let reuseIdentifier = "ReminderCell"

class DateTimeReminderController: UIViewController {
    
    //MARK: - Properties
    
    var reminderNoteCollectionView : UICollectionView!
    
    var remindNotes: [NoteItem] = []
    
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        fetchReminderNotes()
        configureUICollectionView()
        
    }
    
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchReminderNotes(){
        
        NetworkManager.shared.fetchReminderNotes{ result in
            switch result {
            case .success(let notes):
                self.remindNotes = notes
                DispatchQueue.main.async {
                    self.reminderNoteCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    //MARK: - Helper functions
    
    func configureUI(){
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Reminders"
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.app.fill")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
    }
    
    func configureUICollectionView(){
        reminderNoteCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(reminderNoteCollectionView)
        reminderNoteCollectionView.backgroundColor = .lightGray
        reminderNoteCollectionView.dataSource = self
        reminderNoteCollectionView.delegate = self
        reminderNoteCollectionView.register(ReminderCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
}
extension DateTimeReminderController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return remindNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = reminderNoteCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReminderCell
        cell.backgroundColor = .lightGray
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        
        let note = remindNotes[indexPath.row]
        let reminderDate = note.reminder
        
        cell.titleLabel.text = note.title
        cell.noteLabel.text = note.note
        cell.remindDateLabel.text = dateFormatter.string(from: reminderDate ?? Date())
        cell.remindTimeLabel.text = timeFormatter.string(from: reminderDate ?? Date())
        cell.noteList = note
        cell.delegate = self
        
        return cell
    }
}

extension DateTimeReminderController :UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension DateTimeReminderController: RemoveReminderDelegate
{
    func removeReminder(note: NoteItem) {
        var removeUpdateNote = note
        
        let removeReminder = {
            removeUpdateNote.reminder = nil
            NetworkManager.shared.updateData(note: removeUpdateNote)
            self.fetchReminderNotes()
        }
        showAlertWithCancel(title: "Remove Reminder for " + note.title, message: "Are you Sure", buttonText: "Remove", buttonAction: removeReminder)
    }
}
