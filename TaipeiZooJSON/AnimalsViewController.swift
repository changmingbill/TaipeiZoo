//
//  AnimalsViewController.swift
//  TaipeiZooJSON
//
//  Created by 張健民 on 2017/8/24.
//  Copyright © 2017年 CliffC. All rights reserved.
//

import UIKit
import Firebase
class AnimalsViewController: UITableViewController {
   
    let reachability = Reachability(hostName: "www.apple.com")
    let zooAPISite = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613"
    lazy var session: URLSession = {//宣告一個urlsession
        return URLSession(configuration: .default)
    }()
    
    let cellId = "cellId"
    var animals = [Animal]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.title = "TAIPEI ZOO"
//        navigationController?.navigationBar.topItem?.title = "TAIPEI ZOO"
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchAnimal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkIfUserIsLoggedIn()
//        downloadWithSession(WebSite: zooAPISite)
    }
    
    func fetchAnimal(){
        let ref = FIRDatabase.database().reference().child("animals")
        ref.observe(.childAdded, with: { (snapshot) in //childAdded是一個迴圈
            let key = snapshot.key
            let refAnimal = FIRDatabase.database().reference().child("animals").child(key)
            refAnimal.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    let animal = Animal()
                    animal.setValuesForKeys(dictionary)
                    self.animals.append(animal)
                }
              })
                self.attemptReloadOfTable()
            
            
        }, withCancel: nil)
    }
    
    var timer: Timer?
    private func attemptReloadOfTable(){
        
        self.timer?.invalidate() //remove the timer from its run loop.
//        print("we just canceled our timer")
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
//        print("schedule a table reload in 0.1 sec")
    }
    
    
    func handleReloadTable(){
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async {
//            print("we reloaded the table")
            self.tableView.reloadData()
        }
        
    }
       // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            let animal = self.animals[indexPath.row]
            if let name = animal.name, let ename = animal.enName{
            let defaultText = "My favorite animal is " + name + "(" + ename + ")"
            if let urlString = animal.pic0, animal.pic0 != ""{
                if let Url = URL(string: urlString){
                if let imageToShare = NSData(contentsOf: Url)
                {
                    let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                    self.present(activityController, animated: true, completion: nil)
                }
            }

            }else{
                    let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
                    self.present(activityController, animated: true, completion: nil)
                 }
                
            }
        }
        shareAction.backgroundColor = UIColor(r: 48, g: 173, b: 99)
             return [shareAction]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 72
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return animals.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let informationController = InformationViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
            let animal = self.animals[indexPath.row]
            informationController.animal = animal
        navigationController?.pushViewController(informationController, animated: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let animal = animals[indexPath.row]
        cell.textLabel?.text = animal.name
        cell.detailTextLabel?.text = animal.enName
        if let urlString = animal.pic0, animal.pic0 != ""{
            cell.animalImageView.loadImageUsingCacheWithUrlString(urlString: urlString)
        }else{
            cell.animalImageView.image = UIImage(named: "Panda")
        }
//         let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")

        
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

}
