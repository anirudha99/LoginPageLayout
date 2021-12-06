//
//  InboxController.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 27/10/21.
//

import UIKit

class ArchiveController: UIViewController {
    
    //MARK: - Properties
    let layout = UICollectionViewFlowLayout()
    
    var noteCollection : UICollectionView!
    var noteList: [NoteItem] = []
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureCollectionView()
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        if NetworkManager.shared.getUID() != nil {
            getData()
        }
    }
    
    //MARK: - Helper functions
    
    func configureUI(){
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Archive"
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.app.fill")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
    
    func configureCollectionView(){
        
        let itemSize = UIScreen.main.bounds.width/2 - 12
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        noteCollection = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(noteCollection)
        noteCollection.delegate = self
        noteCollection.dataSource = self
        noteCollection.collectionViewLayout = layout
        noteCollection.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifer )
    }
    
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func getData(){
        NetworkManager.shared.resultType(archivedNotes: true, completion: { result in
            switch result {
            case .success(let notes):
                self.updateNoteCollectionViewUI(notes: notes)
            case .failure(let error):
                self.showAlert(title: "Error while fetching notes", message: error.localizedDescription)
            }
        })
    }
    
    func updateNoteCollectionViewUI(notes: [NoteItem]) {
        self.noteList = notes
        print(noteList.count)
        DispatchQueue.main.async {
            self.noteCollection.reloadData()
        }
    }
}

extension ArchiveController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollectionViewCell", for: indexPath) as! NotesCollectionViewCell
        
        cell.noteTitleLabel.text = noteList[indexPath.row].title
        cell.noteLabel.text = noteList[indexPath.row].note
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noteVc = storyboard.instantiateViewController(withIdentifier: "NoteController") as? NoteController
        guard let noteVc = noteVc else{ return }
        noteVc.isNew = false
        noteVc.note = noteList[indexPath.row]
        //        noteVc.noteRealm = notesRealm[indexPath.row]
        
        let presentVC = UINavigationController(rootViewController: noteVc)
        presentVC.modalPresentationStyle = .fullScreen
        present(presentVC, animated: true, completion: nil)
    }
}


