//
//  AnimalsViewController+handler.swift
//  TaipeiZooJSON
//
//  Created by 張健民 on 2017/8/24.
//  Copyright © 2017年 CliffC. All rights reserved.
//

import UIKit
import Firebase
extension AnimalsViewController{
    
    func downloadWithSession(WebSite: String){
        if let url = URL(string: WebSite){
            if isInternetOk() == true{
                let task = session.dataTask(with: url, completionHandler: {
                    (data, response, error) in
                    if error != nil{
                        print(error)
                        return
                    }
                    if let downloadData = data{
                        do{//編碼json
                            let json = try JSONSerialization.jsonObject(with: downloadData, options: [])
                            self.parseJson(json: json)
                            //print("json:\(json)")
                            
                            
                        }catch{
                            
                        }
                    }
                    DispatchQueue.global().async {
                        self.tableView.reloadData()
                    }
                })
                task.resume()
            }else{
                //沒網路， 跳出警告控制器
            }
        }
    }
    
    func parseJson(json: Any){
        if let dictionary = json as? [String: Dictionary<String, Any>]{
            if let result = dictionary["result"]{
                if let dic = result["results"] as? [Dictionary<String, Any>]{
                    let numbers = dic.count-1
                    firebaseUploadWithImage(numbers: numbers, dictionary: dic)
//                    uploadDataIntoDatabase(numbers: numbers, dictionary: dic)
                }
            }
        }
    }
    
func firebaseUploadWithImage(numbers: Int,dictionary: [Dictionary<String, Any>]){

    for index in 0...numbers{
        for i in 0...3{
        let urlStrings = [dictionary[index]["A_Pic01_URL"],dictionary[index]["A_Pic02_URL"],dictionary[index]["A_Pic03_URL"],dictionary[index]["A_Pic04_URL"]]
        if let urlString =  urlStrings[i] as? String{
            if let imageUrl = URL(string: urlString){
                URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                    //download hit an error so lets return out
                    if error != nil{
                        print(error)
                        return
                    }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    if let uploadData = UIImageJPEGRepresentation(downloadedImage, 0.05){
//                        let imageName = NSUUID().uuidString
                        let imageName = i
                        let storageRef = FIRStorage.storage().reference().child("animal_images").child("\(index)").child("\(imageName).jpg")
                        storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                            if error != nil{
                                print(error)
                                return
                            }else{

                            if let imageUrl = metadata?.downloadURL()?.absoluteString {
                                let values = ["pic\(i)": imageUrl, "imageWidth\(i)": downloadedImage.size.width, "imageHeight\(i)": downloadedImage.size.height] as [String : Any]
                                let ref = FIRDatabase.database().reference().child("animals").child("\(index)")
                                ref.updateChildValues(values, withCompletionBlock: { (error, ref) in
                                    print(error)
                                    return
                                })
                            }
                        }
                        })
                    }
                }
            }
        }).resume()
    }
}
            }
//                uploadDataIntoDatabase(index: index, dictionary: dictionary)
        }

      }
    
   
    func uploadDataIntoDatabase(numbers:Int, dictionary: [Dictionary<String, Any>]){
         for index in 0...numbers{
        DispatchQueue.main.sync {
        
            if let name = dictionary[index]["A_Name_Ch"], let enName = dictionary[index]["A_Name_En"], let location = dictionary[index]["A_Location"], let distribution = dictionary[index]["A_Distribution"], let behavior = dictionary[index]["A_Behavior"], let diet = dictionary[index]["A_Diet"], let interpretation = dictionary[index]["A_Interpretation"], let feature = dictionary[index]["A_Feature"], let habitat = dictionary[index]["A_Habitat"]{
                
                let values = ["name": name, "enName": enName, "location": location, "distribution": distribution, "behavior": behavior, "diet": diet, "interpretation": interpretation, "feature": feature, "habitat":habitat]
            
                    let ref = FIRDatabase.database().reference().child("animals").child("\(index)")
                    ref.updateChildValues(values, withCompletionBlock: { (error, ref) in
                        print(error)
                        return
                    })
                

            }
         }
        }
    }
    
    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            //fetchUserAndSetupNavBarTitle()
//            print("login successful")
        }
    }
    
    func handleLogout(){
        //try? FIRAuth.auth()?.signOut()
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        let loginController = LoginController()
        //        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }

    func isInternetOk()->Bool{
        
        if reachability?.currentReachabilityStatus().rawValue == 0{
            return false
        }else{
            return true
        }
    }
    
    
}
