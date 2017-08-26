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
                    
                    firebaseUploadWithImage(dictionary: dic)
                }
            }
        }
    }

        
        func firebaseUploadWithImage(dictionary: [Dictionary<String, Any>]){
            for index in 0...5{
                
                if let urlString = dictionary[index]["A_Pic01_URL"] as? String{
                    if let imageUrl = URL(string: urlString){
                        URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                            //download hit an error so lets return out
                            if error != nil{
                                print(error)
                                return
                            }
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data!){
                            if let uploadData = UIImageJPEGRepresentation(downloadedImage, 0.1){
                                print("download OK")
                                let imageName = NSUUID().uuidString
                                let storageRef = FIRStorage.storage().reference().child("animal_images").child("\(index)").child("\(imageName).jpg")
                                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                                    if error != nil{
                                        print(error)
                                        return
                                    }


                            if let imageUrl = metadata?.downloadURL()?.absoluteString{
                                if let name = dictionary[index]["A_Name_Ch"], let enName = dictionary[index]["A_Name_En"], let location = dictionary[index]["A_Location"], let distribution = dictionary[index]["A_Distribution"], let behavior = dictionary[index]["A_Behavior"], let diet = dictionary[index]["A_Diet"], let interpretation = dictionary[index]["A_Interpretation"], let feature = dictionary[index]["A_Feature"]  {
                                    let values = ["name": name, "enName": enName, "pic01Url": imageUrl, "location": location, "distribution": distribution, "behavior": behavior, "diet": diet, "interpretation": interpretation, "feature": feature]
            
                                self.uploadDataIntoDatabase(index: index, values: values as! [String : String])
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
    }
    
    func uploadDataIntoDatabase(index: Int, values: [String: String]){
        let ref = FIRDatabase.database().reference().child("animals").child("\(index)")
//            var values: [String : Any] = ["name": name, "enName": enName, "pic01Url": pic01Url]
            ref.updateChildValues(values, withCompletionBlock: { (error, ref) in
                print(error)
                return
            })
    }
    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            //            fetchUserAndSetupNavBarTitle()
            print("login successful")
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
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resizeToScreenSize(image: UIImage)->UIImage{
        
        let screenSize = UIScreen.main.bounds.size
        
        
        return resizeImage(image: image, newWidth: screenSize.width)
    }
    

    
}
