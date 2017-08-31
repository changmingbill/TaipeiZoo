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
        if let titleName = animal?.name{
            navigationItem.title = titleName
        }
        self.collectionView!.register(InformationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
//        navigationItem.leftBarButtonItem? = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
//        navigationController?.navigationBar.topItem?.title = "Back"
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //修正旋轉視角bubbleView會置中的問題
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        collectionView?.collectionViewLayout.invalidateLayout()
//    }

    
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
    
    func changeImage(indexPath: IndexPath, i: Int, imageUrls: [String], cell: InformationCell){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            cell.animalImageView.image = nil //將animalImageView清空
            cell.animalImageView.loadImageWithoutCacheWithUrlString(urlString: imageUrls[i])
//            self.collectionView?.reloadItems(at: [indexPath])
         }, completion: { (completed) in

        })
        

    }
    
    var i = 0

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InformationCell
        
        cell.informationViewController = self //這行不打無法從其他class控制本地端class的函式
        
        switch indexPath.item {
            
        case 0:
            cell.leftTextView.isHidden = true
            cell.rightTextView.isHidden = true
            cell.textView.isHidden = true
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
                
                cell.animalImageView.loadImageWithoutCacheWithUrlString(urlString: imageUrl)
                
                if imageUrls.count > 1 {
                    Timer.scheduledTimer(withTimeInterval: 8, repeats: true, block: { (timer) in
                        self.i += 1
                        self.changeImage(indexPath: indexPath, i: self.i, imageUrls: imageUrls, cell: cell)
                        
                        if self.i == imageUrls.count-1{
                            self.i = 0
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
            }else if self.i == 0, let imageHeight = animal?.imageHeight0?.floatValue, let imageWidth = animal?.imageWidth0?.floatValue{
                height = CGFloat(imageHeight / imageWidth * Float(width))
            }else if self.i == 1, let imageHeight = animal?.imageHeight1?.floatValue, let imageWidth = animal?.imageWidth1?.floatValue{
                height = CGFloat(imageHeight / imageWidth * Float(width))
                print(height)
            }else if self.i == 2, let imageHeight = animal?.imageHeight2?.floatValue, let imageWidth = animal?.imageWidth2?.floatValue{
                height = CGFloat(imageHeight / imageWidth * Float(width))
            }else if self.i == 3, let imageHeight = animal?.imageHeight3?.floatValue, let imageWidth = animal?.imageWidth3?.floatValue{
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
                    height = estimateFrameForText(text: text).height + 50
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
                    height = estimateFrameForText(text: text).height + 53
                }
            }
       
        case 7:
            if animal?.behavior == ""{
                height = 0
           
            }else{
                if let text = animal?.behavior{
                    height = estimateFrameForText(text: text).height + 60
                }
            }

        case 8:
            if animal?.diet == ""{
                height = 0
            }else{
                if let text = animal?.diet{
                    height = estimateFrameForText(text: text).height + 50
                }
            }
        case 9:
            if animal?.interpretation == ""{
                 height = 0
            }else{
                if let text = animal?.interpretation{
                    height = estimateFrameForText(text: text).height + 58
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
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIView?
    //my custom zooming logic
    func performZoomInForStaringImageView(startingImageView: UIImageView){
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)//取startingImageView size
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.clear
        zoomingImageView.layer.cornerRadius = 10
        zoomingImageView.clipsToBounds = true
        zoomingImageView.image = startingImageView.image
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        zoomingImageView.isUserInteractionEnabled = true
        if let keyWindow = UIApplication.shared.keyWindow{
            keyWindow.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0 //開始時會看不見
            keyWindow.addSubview(blackBackgroundView!) //這行程式碼在前，所以blackBackgroundView會在zoomingImageView之後呈現
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1 //從0->1，有動畫漸層效果
                //math?
                // h2/w2 = h1/w1
                // h2 = h1 / w1 * w2
                var height: CGFloat = 300
                let width = keyWindow.frame.width
                if self.animal?.pic0 == "" || self.animal?.pic1 == "" || self.animal?.pic2 == "" || self.animal?.pic3 == "" || self.animal?.pic0 == nil {
                    height = 0
                }else if self.i == 0, let imageHeight = self.animal?.imageHeight0?.floatValue, let imageWidth = self.animal?.imageWidth0?.floatValue{
                    height = CGFloat(imageHeight / imageWidth * Float(width))
                }else if self.i == 1, let imageHeight = self.animal?.imageHeight1?.floatValue, let imageWidth = self.animal?.imageWidth1?.floatValue{
                    height = CGFloat(imageHeight / imageWidth * Float(width))
                    print(height)
                }else if self.i == 2, let imageHeight = self.animal?.imageHeight2?.floatValue, let imageWidth = self.animal?.imageWidth2?.floatValue{
                    height = CGFloat(imageHeight / imageWidth * Float(width))
                }else if self.i == 3, let imageHeight = self.animal?.imageHeight3?.floatValue, let imageWidth = self.animal?.imageWidth3?.floatValue{
                    height = CGFloat(imageHeight / imageWidth * Float(width))
                }
                    
                    //keyWindow是整個app的view
                    zoomingImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
                
            }, completion: { (completed) in
                //                zoomOutImageView.removeFromSuperview()
            })
            
            
        }
        
    }
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view{
            //need to animate back out to controller
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.layer.cornerRadius = 10
                zoomOutImageView.clipsToBounds = true
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
            }, completion: { (completed: Bool) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
            
        }
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
