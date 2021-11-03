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
import RealmSwift

let cellIdentifer = "NotesCollectionViewCell"

class HomeViewController: UIViewController {
    
    //MARK: – Properties
    var delegate: HomeViewControllerDelegate?
    var noteCollection : UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let realmInstance = try! Realm()
    var searching = false                   //bool value for search bar searching
    
    var filteredNotes : [NoteItem] = []     //for the search and filter
    var notesRealm : [NotesItem] = []       //relam array
    var noteList: [NoteItem] = []           //firebase array
    
    var isListView = false                  //bool value for toggling between list and grid view
    var hasMoreNotes = true
    
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
        //        fetchData()
        //        fetchNoteRealm()
//        self.noteCollection.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hasMoreNotes = true
        getNotesforPag()
    }
    
    //MARK: - Handlers
    
    func configureNavigationBar(){
        
        view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .gray
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        noteCollection?.collectionViewLayout = layout
        
        navigationItem.title = "Home Screen"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem (image: UIImage(systemName: "list.bullet.circle")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        toggleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet")?.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(toggleButtontapped))
        
        addButton = UIBarButtonItem(image: UIImage(systemName: "plus.app.fill")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddMethod))
        navigationItem.rightBarButtonItems = [addButton, toggleButton]
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
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
    
    //fetch data from firebase and reload
    //    func fetchData(){
    //        NetworkManager.shared.getData(completion: { notes in
    //            self.noteList = notes
    //            DispatchQueue.main.async {
    //                self.noteCollection?.reloadData()
    //            }
    //        })
    //    }
    
    //fetch notes from realm data
    //    func fetchNoteRealm(){
    //        RealmManager.shared.fetchNotes{ notesArray in
    //            self.notesRealm = notesArray
    //        }
    //        //print(notesRealm)
    //    }
    
    
    //delete function
    @objc func deleteNote(_ sender: UIButton){
        print("Delete button pressed")
        
        let deleteNote = noteList[sender.tag]
        
        print(deleteNote.title)
        
        NetworkManager.shared.deleteData(note: deleteNote)
        RealmManager.shared.deleteNote(index: sender.tag)

        noteList.remove(at: sender.tag)
        noteCollection.reloadData()
    }
    
    //toggle list and grid view
    @objc func toggleButtontapped(){
        if isListView {
            isListView = false
            toggleButton.image = UIImage(systemName: "list.bullet")?.withRenderingMode(.alwaysOriginal)
        } else {
            isListView = true
            toggleButton.image = UIImage(systemName: "rectangle.split.2x1")?.withRenderingMode(.alwaysOriginal)
        }
        noteCollection.reloadData()
    }
    
    //Pagination data
    func getNotesforPag(){
        
        RealmManager.shared.fetchNotes { notesArray in
            self.notesRealm = notesArray
        }
//        RealmManager.shared.fetchNotesPag()
        NetworkManager.shared.fetchNoteData { NoteItem in
            
            if NoteItem.count < 8 {
                self.hasMoreNotes = false
            }
            self.noteList = NoteItem
            print("NOTESSSSSS!!!!!!!!!!!!!!!!")
//            print(self.noteList)
            self.filteredNotes = self.noteList
            DispatchQueue.main.async {
                self.noteCollection.reloadData()
            }
        }
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
    
    func createspinnerFooter()-> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searching ? filteredNotes.count : noteList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NotesCollectionViewCell?
        if indexPath.row == noteList.count - 1 && hasMoreNotes {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as?
            NotesCollectionViewCell
            cell?.activityIndicator.startAnimating()
            return cell!
        }
        else{
             cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollectionViewCell", for: indexPath) as! NotesCollectionViewCell
        }
        
        let note = searching ?  filteredNotes[indexPath.row] : noteList[indexPath.row]
        
        cell?.note = note
        
//        cell.noteTitleLabel.text = note.title
//        cell.noteLabel.text = note.note
        
        cell?.noteDeleteButton.tag = indexPath.row
        cell?.noteDeleteButton.addTarget(self, action: #selector(deleteNote), for: .touchUpInside)
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noteVc = storyboard.instantiateViewController(withIdentifier: "NoteController") as? NoteController
        guard let noteVc = noteVc else{ return }
        
        noteVc.isNew = false
        noteVc.note = noteList[indexPath.row]
        noteVc.noteRealm = notesRealm[indexPath.row]
        
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

extension HomeViewController: UISearchResultsUpdating{
    //search button function
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        let count = searchController.searchBar.text?.count
        if !searchText.isEmpty {
            searching = true
            filteredNotes.removeAll()
            filteredNotes = noteList.filter({$0.title.prefix(count!).lowercased() == searchText.lowercased()})
            //            filteredNotes = noteList.filter({$0.title.lowercased() == searchText.lowercased()})
        }
        else{
            searching = false
            filteredNotes.removeAll()
            filteredNotes = noteList
        }
        noteCollection.reloadData()
    }
}

extension HomeViewController: UIScrollViewDelegate{
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView){
//
//        let position = scrollView.contentOffset.y
//
//        print("position - \(position)")
//        print("Frame size - \(noteCollection.contentSize.height-scrollView.frame.size.height-100)")
//
//        if position > (noteCollection.contentSize.height-scrollView.frame.size.height-100) {
//
//            //fetch more data
//            print("Started Fetching - ++++++++++++++++++===============")
//            guard hasMoreNotes else { return}
//
//            print(fetchingMoreNotes)
//
//            guard !fetchingMoreNotes else{
//                print("Fetching completed - !!!!!!!!!!!!!!!11111111112222222")
//                return
//            }
////            if fetchingMoreNotes == false {
////                fetchingMoreNotes = true
////            }
//            print("scrolled!!!!! - $$$$$$$$$$$$$$$$$$$$$$$$$$%%%%%%%")
//
//            NetworkManager.shared.fetchMoreNotesData { notes in
//                if notes.count < 8 {
//                    self.hasMoreNotes = false
//                    print(">>>>>>>>>>>>>>>>>>>")
//                }
//                self.noteList.append(contentsOf: notes)
////                self.filteredNotes = self.noteList
//                self.noteCollection.reloadData()
//            }
//        }
//    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height{
            print("scroll height- %%%%%%%%")
            guard hasMoreNotes else { return}
            guard !fetchingMoreNotes else{
                print("Fetching completed - !!!!!!!!!!!!!!!11111111112222222")
                return
            }
            NetworkManager.shared.fetchMoreNotesData { notes in
                if notes.count < 8 {
                    self.hasMoreNotes = false
                    print(">>>>>>>>>>>>>>>>>>>")
                }
                self.noteList.append(contentsOf: notes)
                //                self.filteredNotes = self.noteList
                self.noteCollection.reloadData()
            }
        }
    }
}
