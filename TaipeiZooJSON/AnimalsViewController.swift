//
//  AnimalsViewController.swift
//  TaipeiZooJSON
//
//  Created by 張健民 on 2017/8/24.
//  Copyright © 2017年 CliffC. All rights reserved.
//

import UIKit
import Firebase
import CoreData
class AnimalsViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate{
   
    let reachability = Reachability(hostName: "www.apple.com")
    let zooAPISite = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613"
    lazy var session: URLSession = {//宣告一個urlsession
        return URLSession(configuration: .default)
    }()
    
    let cellId = "cellId"
    var animals = [Animal]()
    var animalM: AnimalM!
    
    var searchResults = [Animal]()
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "addFile")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showSavingControllerForAnimal))
        
        navigationItem.title = "TAIPEI ZOO"
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
         navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(r: 5, g: 122, b: 251), NSFontAttributeName: UIFont.systemFont(ofSize: 21)]
        
        fetchAnimal()
        setupSearchController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        checkIfUserIsLoggedIn()
//         downloadWithSession(WebSite: zooAPISite)
    }

    
    
    func Dismiss(){
        dismiss(animated: true) {
            print("Dismiss Complete")
        }
    }

    
    func handleSavingController(){
       let savingController = SavingController()
        navigationController?.pushViewController(savingController, animated: true)
//        let navController = UINavigationController(rootViewController: savingController)
//        present(navController, animated: true, completion: nil)
    }
    
    func showSavingControllerForAnimal(){
        let savingController = SavingController() //原本不存在，就要實體化SavingController()
        navigationController?.pushViewController(savingController, animated: true)
//        let navController = UINavigationController(rootViewController: savingController)
//        present(navController, animated: true, completion: nil)
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
        searchResults = animals.filter({ (animal) -> Bool in
            
            if let name = animal.name, let enName = animal.enName{
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

//    
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchWord = searchController.searchBar.text{
//            resultArray = animals.filter({
//                (stuff) -> Bool in
//                stuff.lowercased().contains(searchWord.lowercased())
//            })
//        }
//        resultController.tableView.reloadData()
//    }
    
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
        
        
        let saveAction = UITableViewRowAction(style: .default, title: "Save") { (action, indexPath) in
            let animal = self.animals[indexPath.row]
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                self.animalM = AnimalM(context: appDelegate.persistentContainer.viewContext)
                if let name = animal.name{
                    self.animalM.name = name
                }
                if let enName = animal.enName{
                    self.animalM.enName = enName
                }
                if let location = animal.location{
                    self.animalM.location = location
                }
                if let distribution = animal.distribution{
                    self.animalM.distribution = distribution
                }
                if let habitat = animal.habitat{
                    self.animalM.habitat = habitat
                }
                if let behavior = animal.behavior{
                    self.animalM.behavior = behavior
                }
                if let diet = animal.diet{
                    self.animalM.diet = diet
                }
                if let feature = animal.feature{
                    self.animalM.feature = feature
                }
                if let interpretation = animal.interpretation{
                    self.animalM.interpretation = interpretation
                }
                
                if let urlString = animal.pic0, animal.pic0 != "",animal.pic0 != nil{
                    self.animalM.imageHeight0 = animal.imageHeight0 as! Float
                    self.animalM.imageWidth0 = animal.imageWidth0 as! Float
                    if let Url = URL(string: urlString)  {
                        self.animalM.pic0 = NSData(contentsOf: Url)
                    }
                }
                
                if let urlString = animal.pic1, animal.pic1 != "",animal.pic1 != nil{
                    self.animalM.imageHeight1 = animal.imageHeight1 as! Float
                    self.animalM.imageWidth1 = animal.imageWidth1 as! Float
                    if let Url = URL(string: urlString)  {
                        self.animalM.pic1 = NSData(contentsOf: Url)
                    }
                }
                
                if let urlString = animal.pic2, animal.pic2 != "",animal.pic2 != nil{
                    self.animalM.imageHeight2 = animal.imageHeight2 as! Float
                    self.animalM.imageWidth2 = animal.imageWidth2 as! Float
                    if let Url = URL(string: urlString)  {
                        self.animalM.pic2 = NSData(contentsOf: Url)
                    }
                }
                
                if let urlString = animal.pic3, animal.pic3 != "",animal.pic3 != nil{
                    self.animalM.imageHeight3 = animal.imageHeight3 as! Float
                    self.animalM.imageWidth3 = animal.imageWidth3 as! Float
                    if let Url = URL(string: urlString)  {
                        self.animalM.pic3 = NSData(contentsOf: Url)
                    }
                }
                appDelegate.saveContext()
                let alert = UIAlertController(title: nil, message: "Save Successfully", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }

        }
        saveAction.backgroundColor = UIColor(r: 218, g: 100, b: 70)
             return [saveAction,shareAction]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 72
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive{
            return searchResults.count
        }else{
            return animals.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let informationController = InformationViewController(collectionViewLayout: UICollectionViewFlowLayout())
            informationController.animalsViewController = self  //推過去時就要先告知
             let animal = (searchController.isActive) ? searchResults[indexPath.row] : animals[indexPath.row]
            informationController.animal = animal
        let navController = UINavigationController(rootViewController: informationController)
        navController.modalTransitionStyle = .flipHorizontal
        present(navController, animated: true, completion: nil)
//        navigationController?.pushViewController(informationController, animated: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let animal = (searchController.isActive) ? searchResults[indexPath.row] : animals[indexPath.row]

        cell.textLabel?.text = animal.name
        cell.detailTextLabel?.text = animal.enName
        
        if let urlString = animal.pic0, let name = animal.name, animal.pic0 != "",animal.name != ""{
            
            if UserDefaults.standard.object(forKey: name) == nil{
                urlStringSaveToFile(urlString: urlString, fileName: name)
            }

            if let imageData = UserDefaults.standard.object(forKey: name){
            if let image = UIImage(data: imageData as! Data){
               cell.animalImageView.image = image
            }
            }
                        else{
                 cell.animalImageView.loadImageUsingCacheWithUrlString(urlString: urlString)
            }
        }
        
        return cell
    }
    
    func urlStringSaveToFile(urlString: String, fileName: String){
//        print(filePath)
//        let session = URLSession(configuration: URLSessionConfiguration.default)
//        let fileURL = URL(fileURLWithPath: filePath)
        
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            //download hit an error so lets return out
            if error != nil{
                print(error)
                return
            }
            DispatchQueue.main.async {
             if let imageData = data{
                guard UserDefaults.standard.object(forKey: fileName) == nil else{
                    return
                }
                UserDefaults.standard.set(imageData, forKey: fileName)
                UserDefaults.standard.synchronize()
//                print("Save Successfully")
//                self.saveToFile(data: data!, fileURL: fileURL)
             }
            }
            
        }).resume()

    }
    
    func saveToFile(data: Data, fileURL: URL){
        do{
            print(fileURL)
            print(data)
            try data.write(to: fileURL)
        }catch{
            print("Save Fail")
        }
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
