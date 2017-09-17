//
//  SavingController.swift
//  TaipeiZooJSON
//
//  Created by 張健民 on 2017/9/3.
//  Copyright © 2017年 CliffC. All rights reserved.
//

import UIKit
import CoreData
class SavingController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    let cellId = "cell"
    var animalMs:[AnimalM] = []
    var searchResults = [AnimalM]()
    var searchController = UISearchController()
    var fetchResultController: NSFetchedResultsController<AnimalM>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "くBack", style: .plain, target: self, action: #selector(PopBack))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        navigationItem.title = "My Favorites"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(r: 5, g: 122, b: 251), NSFontAttributeName: UIFont.systemFont(ofSize: 21)]
        //(name: "mplus-1c-regular", ofSize: 21)!]

        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(r: 5, g: 122, b: 251), NSFontAttributeName: UIFont.systemFont(ofSize: 21)], for: .normal)
        setupFetchRequest()
        setupSearchController()
        }
    
    // MARK: - searchController
    func setupSearchController(){
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Animals..."
        searchController.searchBar.tintColor = UIColor.white //Cancel字的顏色
        searchController.searchBar.barTintColor = UIColor(r: 81, g: 126, b: 185)
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        definesPresentationContext = true //推到另一個controller，原本Controller的View會被覆蓋
        
    }
    // MARK: - Search filter
    func filterContent(for searchText: String){
        searchResults = animalMs.filter({ (animal) -> Bool in
            
            if let name = animal.name, let enName = animal.enName{
                //                if let name = restaurant.name, let location = restaurant.location {
                //                    let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                //                    return isMatch
                //                }
                
                let isMatchName = name.localizedCaseInsensitiveContains(searchText)
                let isMatchEnName = enName.localizedCaseInsensitiveContains(searchText)
                
                if isMatchName{
                    return isMatchName
                }else if isMatchEnName{
                    return isMatchEnName
                }
                
            }
            return false
        })
    }
    
    // MARK: - SearchResult
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    //在搜尋狀態列不能執行編輯動作(editActions)
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return searchController.isActive ? false :  true
    }

    
    // MARK: - FetchRequest
    func setupFetchRequest(){
        let fetchRequest: NSFetchRequest<AnimalM> = AnimalM.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do{
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects{
                    animalMs = fetchedObjects
//                    print(animalMs[0].name, animalMs[0].enName )
                }
            }catch{
                print(error)
            }
        }
    }
    
    // MARK: - NSFetchedResultControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            if let newIndexPath = newIndexPath{
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchObjects = controller.fetchedObjects{
            animalMs = fetchObjects as! [AnimalM]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - share & delete actions
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Social Sharing Button
        let shareAction = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            let animal = self.animalMs[indexPath.row]
            if let name = animal.name, let ename = animal.enName{
                let defaultText = "My favorite animal is " + name + "(" + ename + ")"
                if let imageData = animal.pic0, animal.pic0 != nil{
                        let imageToShare = NSData(data: imageData as Data)
                            let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                            self.present(activityController, animated: true, completion: nil)
                    
                }else{
                    let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
                    self.present(activityController, animated: true, completion: nil)
                }
                
            }
        }
        shareAction.backgroundColor = UIColor(r: 48, g: 173, b: 99)
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
            
            // Delete the row from the data source
            //            self.restaurants.remove(at: indexPath.row)
            //            self.tableView.deleteRows(at: [indexPath], with: .fade)
            //如果用optional binding的話，as後就一定要加?號
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                let context = appDelegate.persistentContainer.viewContext
                let animalToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(animalToDelete)
                
                appDelegate.saveContext()
            }
            
        })
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }


    
    func Dismiss(){
        dismiss(animated: true) { 
        }
    }
    
    func PopBack(){
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let savingInfoController = SavingInfoViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let animal = (searchController.isActive) ? searchResults[indexPath.row] : animalMs[indexPath.row]
        savingInfoController.animalM = animal
        //        tableView.tableHeaderView = nil
//        let navController = UINavigationController(rootViewController: savingInfoController)
//        present(navController, animated: true, completion: nil)
        navigationController?.pushViewController(savingInfoController, animated: true)
        
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return searchResults.count
        }else{
            return animalMs.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let animal = (searchController.isActive) ? searchResults[indexPath.row] : animalMs[indexPath.row]
        cell.textLabel?.text = animal.name
        cell.detailTextLabel?.text = animal.enName
        if let imageData = animal.pic0, animal.pic0 != nil{
            cell.animalImageView.image = UIImage(data: imageData as Data)
        }else{
            cell.animalImageView.image = UIImage(named: "Panda")
        }


        return cell
    }
    

        func clearCoreDataStore() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        for i in 0...delegate.persistentContainer.managedObjectModel.entities.count-1 {
            let entity = delegate.persistentContainer.managedObjectModel.entities[i]
            
            do {
                let query = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                let deleterequest = NSBatchDeleteRequest(fetchRequest: query)
                try context.execute(deleterequest)
                try context.save()
                
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }

    

}
