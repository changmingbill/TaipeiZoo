//
//  Extensions.swift
//  gameofchats
//
//  Created by 張健民 on 2017/8/9.
//  Copyright © 2017年 CliffC. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>() //設定快取

extension UIImageView{
    
    func loadImageUsingCacheWithUrlString(urlString: String){
        
        self.image = nil //會先留白再顯示image
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
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
                if let downloadedImage = UIImage(data: data!){
                    //將image裝進cache，可不用重複下載
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
                
            }
            
        }).resume()

    }
    
    
    
    func loadImageWithoutCacheWithUrlString(urlString: String){
        
        self.image = nil //會先留白再顯示image
        
        //otherwise fire off a new download
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
                if let downloadedImage = UIImage(data: data!){
                    
                    self.image = downloadedImage
                }
                
            }
            
        }).resume()
        
        
    }

}

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha:1)
    }
}

extension UIScrollView {
    var currentPage:Int{
        return Int(floor((self.contentOffset.x-(0.5*(self.frame.size.width)))/(self.frame.width))) + 1
    }
}

