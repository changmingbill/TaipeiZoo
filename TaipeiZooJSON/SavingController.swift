//
//  SavingController.swift
//  TaipeiZooJSON
//
//  Created by 張健民 on 2017/9/3.
//  Copyright © 2017年 CliffC. All rights reserved.
//

import UIKit
import CoreData
class SavingController: UITableViewController, NSFetchedResultsControllerDelegate {
    let cellId = "cell"
    var animalMs:[AnimalM] = []
//    var cars:[Car] = []
    var fetchResultController: NSFetchedResultsController<AnimalM>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "＜ Back", style: .plain, target: self, action: #selector(PopBack))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)


        setupFetchRequest()
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
    
//    // MARK: - NSFetchedResultControllerDelegate
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type{
//        case .insert:
//            if let newIndexPath = newIndexPath{
//                tableView.insertRows(at: [newIndexPath], with: .fade)
//            }
//        case .delete:
//            if let indexPath = indexPath{
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//        case .update:
//            if let indexPath = indexPath{
//                tableView.reloadRows(at: [indexPath], with: .fade)
//            }
//        default:
//            tableView.reloadData()
//        }
//        
//        if let fetchObjects = controller.fetchedObjects{
//            animalMs = fetchObjects as! [AnimalM]
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }

    
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalMs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let animal = animalMs[indexPath.row]

        cell.textLabel?.text = animal.name
        cell.detailTextLabel?.text = animal.enName
        if let imageData = animal.pic0, animal.pic0 != nil{
            cell.animalImageView.image = UIImage(data: imageData as Data)
        }else{
            cell.animalImageView.image = UIImage(named: "Panda")
        }


        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
