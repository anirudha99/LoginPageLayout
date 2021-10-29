//
//  HomeViewController.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 19/10/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import Firebase
import FirebaseFirestore

let cellIdentifer = "NotesCollectionViewCell"

class HomeViewController: UIViewController {
    
    //MARK: – Properties
    var delegate: HomeViewControllerDelegate?
    
    var noteCollection : UICollectionView!
    
    var noteList: [NoteItem] = []
    
    var isListView = false
    
    var toggleButton = UIBarButtonItem()
    
    var addButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUserAlreadyLoggedIn()
        configureNavigationBar()
        configureCollectionView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        fetchData()
    }
    
    //MARK: - Handlers
    
    @objc func handleMenuToggle(){
        delegate?.handleMenuToggle(forMenuOption: nil)
        print("Toggle menu")
    }
    
    @objc func handleAddMethod(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let noteVc = storyboard.instantiateViewController(withIdentifier: "NoteController") as? NoteController
        
        print(noteList)
        noteVc?.isNew = true
        
        guard let noteVc = noteVc else{ return }
        
        let presentVC = UINavigationController(rootViewController: noteVc)
        presentVC.modalPresentationStyle = .fullScreen
        present(presentVC, animated: true, completion: nil)
    }
    
    func configureNavigationBar(){
        
        view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .gray
        
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
//        let itemSize = UIScreen.main.bounds.width/2 - 14
//        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        noteCollection?.collectionViewLayout = layout
        
        navigationItem.title = "Home Screen"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem (image: UIImage(systemName: "list.bullet.circle")?.withRenderingMode(.automatic), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        toggleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet")?.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(toggleButtontapped))
        
        addButton = UIBarButtonItem(image: UIImage(systemName: "plus.app.fill")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddMethod))
        
        navigationItem.rightBarButtonItems = [addButton, toggleButton]
        
    }
    
    //configuring collection view
    func configureCollectionView(){
        noteCollection = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(noteCollection)
        noteCollection.delegate = self
        noteCollection.dataSource = self
        noteCollection.backgroundColor = .systemBackground
        noteCollection.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifer )
    }
    
    //fetch data from firebase and reload
    func fetchData(){
        NetworkManager.shared.getData(completion: { notes in
            self.noteList = notes
            DispatchQueue.main.async {
                self.noteCollection?.reloadData()
            }
        })
    }
    
    //delete function
    @objc func deleteNote(_ sender: UIButton){
        print("Delete button pressed")
        let deleteNote = noteList[sender.tag]
        print(deleteNote.title)
        NetworkManager.shared.deleteData(note: deleteNote)
        noteList.remove(at: sender.tag)
        noteCollection.reloadData()
    }
    
    //toggle list and grid view
    @objc func toggleButtontapped(){
        if isListView {
            isListView = false
        } else {
            isListView = true
        }
        noteCollection.reloadData()
    }
    
    //check if user is already logged in
    func checkUserAlreadyLoggedIn(){
        //Previous sign in
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil && NetworkManager.shared.getUID() == nil {
                print("Error in login!!")
                // Show the app's signed-out state.
                DispatchQueue.main.async {
                    self.transitionToMainPage()
                }
                return
            }
        }
        
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in
            return
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollectionViewCell", for: indexPath) as! NotesCollectionViewCell
//        cell.backgroundColor =
        cell.noteTitleLabel.text = noteList[indexPath.row].title
        cell.noteLabel.text = noteList[indexPath.row].note
        
        cell.noteDeleteButton.tag = indexPath.row
        cell.noteDeleteButton.addTarget(self, action: #selector(deleteNote), for: .touchUpInside)
        
//        cell.listViewButton.addTarget(self, action: #selector(toggleButtontapped), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noteVc = storyboard.instantiateViewController(withIdentifier: "NoteController") as? NoteController
        guard let noteVc = noteVc else{ return }
        
        noteVc.isNew = false
        noteVc.note = noteList[indexPath.row]
        
        let presentVC = UINavigationController(rootViewController: noteVc)
        presentVC.modalPresentationStyle = .fullScreen
        present(presentVC, animated: true, completion: nil)
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = UIScreen.main.bounds.width/2 - 14 //grid size
        //       width: view.frame.width - 20
        if isListView{
            return CGSize(width: view.frame.width - 20, height: 200)
        } else{
            return CGSize(width: itemSize , height: itemSize)
        }
    }
}
