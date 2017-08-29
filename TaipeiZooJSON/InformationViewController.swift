//
//  InformationViewController.swift
//  TaipeiZooJSON
//
//  Created by 張健民 on 2017/8/25.
//  Copyright © 2017年 CliffC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class InformationViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var animal: Animal?
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true //可以維持collectionView顯示保持回彈狀態
        collectionView?.backgroundColor = UIColor.white // view.backgroundColor = UIColor.white這個沒效果
        collectionView?.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 8, right: 0) //設定collectionView與view間的邊界條件


        self.collectionView!.register(InformationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
       
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //修正旋轉視角bubbleView會置中的問題
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(0, 0, 0, 0)
//    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little prepvartion before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func changeImage(i: Int, imageUrls: [String], cell: InformationCell){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            cell.animalImageView.loadImageUsingCacheWithUrlString(urlString: imageUrls[i])
        }, completion: { (completed) in
//            print(i)
        })
        

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InformationCell

        switch indexPath.item {
            
        case 0:
//            if let urlString = animal?.pic0{
//                cell.animalImageView.loadImageUsingCacheWithUrlString(urlString: urlString)
//            }
            var imageUrls = [String]()
            cell.bubbleView.backgroundColor = UIColor.clear
            
            if let url0 = animal?.pic0, animal?.pic0 != "",animal?.pic0 != nil{
                imageUrls.append(url0)
            }
            if let url1 = animal?.pic1, animal?.pic1 != "", animal?.pic1 != nil{
                imageUrls.append(url1)
            }
            if let url2 = animal?.pic2, animal?.pic2 != "", animal?.pic2 != nil{
                imageUrls.append(url2)
            }
            if let url3 = animal?.pic3, animal?.pic3 != "", animal?.pic3 != nil{
                imageUrls.append(url3)
            }
            
            if let imageUrl = animal?.pic0{
                
                cell.animalImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
                
                if imageUrls.count > 1 {
                    var i = 0
                    Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                        
                        self.changeImage(i: i,imageUrls: imageUrls, cell: cell)
                        i += 1
                        if i == imageUrls.count{
                            i = 0
                        }
                        
                    })

                }
                
            }
            
            
            
        
            
        case 1:
            cell.leftTextView.text = "Name : "
            cell.rightTextView.text = animal?.name
            cell.leftTextViewWidthAnchor?.constant = 65
        case 2:
            cell.leftTextView.text = "English Name : "
            cell.rightTextView.text = animal?.enName
            
        case 3:
            cell.leftTextView.text = "Location : "
            cell.rightTextView.text = animal?.location
            cell.leftTextViewWidthAnchor?.constant = 85
        case 4:
            cell.leftTextView.text = "Distribution : "
            cell.textView.text = animal?.distribution
            if animal?.distribution == ""{
                cell.isHidden = true
            }

        case 5:
            cell.leftTextView.text = "Habitat : "
            cell.textView.text = animal?.habitat
            if animal?.habitat == ""{
                cell.isHidden = true
            }
        case 6:
            cell.leftTextView.text = "Feature : "
            cell.textView.text = animal?.feature
            if animal?.feature == ""{
                cell.isHidden = true
            }

        case 7:
            cell.leftTextView.text = "Behavior : "
            cell.textView.text = animal?.behavior
            if animal?.behavior == ""{
                cell.isHidden = true
            }

        case 8:
            cell.leftTextView.text = "Diet : "
           cell.textView.text = animal?.diet
           if animal?.diet == ""{
            cell.isHidden = true
            }

           
        case 9:
            cell.leftTextView.text = "Interpretation : "
            cell.textView.text = animal?.interpretation
            if animal?.interpretation == ""{
                cell.isHidden = true
            }

            
        default:
            break
        }
   
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 20
        let width = UIScreen.main.bounds.width

        switch indexPath.item {
          
        case 0:
            if animal?.pic0 == "" || animal?.pic1 == "" || animal?.pic2 == "" || animal?.pic3 == "" || animal?.pic0 == nil {
                height = 0
            }else if let imageHeight = animal?.imageHeight0?.floatValue, let imageWidth = animal?.imageWidth0?.floatValue{
                height = CGFloat(imageHeight / imageWidth * Float(width))
            }
        case 1:
            if animal?.name == ""{
                height = 0
            }else{
                if let text = animal?.name{
                    height = estimateFrameForText(text: text).height + 20
                }
            }
        case 2:
            if animal?.enName == ""{
                height = 0
            }else{
                if let text = animal?.enName{
                    height = estimateFrameForText(text: text).height + 20
                }
            }

        case 3:
            if animal?.location == ""{
                height = 0
            }else{
                if let text = animal?.location{
                    height = estimateFrameForText(text: text).height + 20
                }
            }

        case 4:
            if animal?.distribution == ""{
                height = 0
            }else{
                if let text = animal?.distribution{
                    height = estimateFrameForText(text: text).height + 58
                }
            }

        case 5:
            if animal?.habitat == ""{
                height = 0
            }else{
                if let text = animal?.habitat{
                    height = estimateFrameForText(text: text).height + 58
                }
            }
  
        case 6:
            if animal?.feature == ""{
                height = 0
            }else{
                if let text = animal?.feature{
                    height = estimateFrameForText(text: text).height + 58
                }
            }
       
        case 7:
            if animal?.behavior == ""{
                height = 0
           
            }else{
                if let text = animal?.behavior{
                    height = estimateFrameForText(text: text).height + 58
                }
            }

        case 8:
            if animal?.diet == ""{
                height = 0
            }else{
                if let text = animal?.diet{
                    height = estimateFrameForText(text: text).height + 60
                }
            }
        case 9:
            if animal?.interpretation == ""{
                 height = 0
            }else{
                if let text = animal?.interpretation{
                    height = estimateFrameForText(text: text).height + 60
                }
            }
        default:
            break
        }
        
        
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin) //使用union可以同時包含兩個屬性:usesFontLeading,usesLineFragmentOrigin
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
