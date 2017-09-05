//
//  SavingInfoViewController.swift
//  TaipeiZooJSON
//
//  Created by 張健民 on 2017/9/5.
//  Copyright © 2017年 CliffC. All rights reserved.
//

import UIKit
import CoreData
private let reuseIdentifier = "Cell"

class SavingInfoViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var timer: Timer?
    var animalM: AnimalM?
    var imageData = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true //可以維持collectionView顯示保持回彈狀態
        collectionView?.backgroundColor = UIColor.white // view.backgroundColor = UIColor.white這個沒效果
        collectionView?.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 8, right: 0) //設定collectionView與view間的邊界條件
        if let titleName = animalM?.name{
            navigationItem.title = titleName
        }
        self.collectionView!.register(InformationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "＜ Back", style: .plain, target: self, action: #selector(PopBack))
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(r: 5, g: 122, b: 251), NSFontAttributeName: UIFont.systemFont(ofSize: 21)]
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(r: 5, g: 122, b: 251), NSFontAttributeName: UIFont.systemFont(ofSize: 21)], for: .normal)
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(r: 5, g: 122, b: 251), NSFontAttributeName: UIFont.systemFont(ofSize: 21)], for: .normal)
    }
    
    func Dismiss(){
        dismiss(animated: true) {
            
        }
    }
    
    func PopBack(){
        navigationController?.popViewController(animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }


   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func changeImage(indexPath: IndexPath, i: Int, imageData: [Any], cell: InformationCell){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            cell.animalImageView.image = nil //將animalImageView清空
            cell.animalImageView.image = UIImage(data: imageData[i] as! Data)
            
            //            self.collectionView?.reloadItems(at: [indexPath])
        }, completion: { (completed) in
            
        })
        
    }


    var i = 0
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InformationCell
        
        cell.savingInfoController = self //這行不打無法從其他class控制本地端class的函式
        
        switch indexPath.item {
            
        case 0:
            cell.leftTextView.isHidden = true
            cell.rightTextView.isHidden = true
            cell.textView.isHidden = true
            
            cell.bubbleView.backgroundColor = UIColor.clear
            
            if let imageData0 = animalM?.pic0, animalM?.pic0 != nil{
                imageData.append(imageData0)
            }
            if let imageData1 = animalM?.pic1, animalM?.pic1 != nil{
                imageData.append(imageData1)
            }
            if let imageData2 = animalM?.pic2, animalM?.pic2 != nil{
                imageData.append(imageData2)
            }
            if let imageData3 = animalM?.pic3, animalM?.pic3 != nil{
                imageData.append(imageData3)
            }
            
            if let imageDatum = animalM?.pic0{
                
                cell.animalImageView.image = UIImage(data: imageDatum as Data)
                
                if imageData.count > 1 {
                    Timer.scheduledTimer(withTimeInterval: 8, repeats: true, block: { (timer) in
                        self.i += 1
                        self.changeImage(indexPath: indexPath, i: self.i, imageData: self.imageData, cell: cell)
                        
                        if self.i == self.imageData.count-1{
                            self.i = 0
                        }
                        
                    })
                }
                
            }
            
        case 1:
            cell.leftTextView.text = "Name : "
            cell.rightTextView.text = animalM?.name
            cell.leftTextViewWidthAnchor?.constant = 65
        case 2:
            cell.leftTextView.text = "English Name : "
            cell.rightTextView.text = animalM?.enName
            
        case 3:
            cell.leftTextView.text = "Location : "
            cell.rightTextView.text = animalM?.location
            cell.leftTextViewWidthAnchor?.constant = 85
        case 4:
            cell.leftTextView.text = "Distribution : "
            cell.textView.text = animalM?.distribution
            if animalM?.distribution == ""{
                cell.isHidden = true
            }
            
        case 5:
            cell.leftTextView.text = "Habitat : "
            cell.textView.text = animalM?.habitat
            if animalM?.habitat == ""{
                cell.isHidden = true
            }
        case 6:
            cell.leftTextView.text = "Feature : "
            cell.textView.text = animalM?.feature
            if animalM?.feature == ""{
                cell.isHidden = true
            }
            
        case 7:
            cell.leftTextView.text = "Behavior : "
            cell.textView.text = animalM?.behavior
            if animalM?.behavior == ""{
                cell.isHidden = true
            }
            
        case 8:
            cell.leftTextView.text = "Diet : "
            cell.textView.text = animalM?.diet
            if animalM?.diet == ""{
                cell.isHidden = true
            }
            
            
        case 9:
            cell.leftTextView.text = "Interpretation : "
            cell.textView.text = animalM?.interpretation
            if animalM?.interpretation == ""{
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
            if animalM?.pic0 == nil , animalM?.pic1 == nil , animalM?.pic2 == nil , animalM?.pic3 == nil {
                height = 0
            }else if self.i == 0, let imageHeight = animalM?.imageHeight0, let imageWidth = animalM?.imageWidth0{
                height = CGFloat(imageHeight / imageWidth * Float(width))
            }else if self.i == 1, let imageHeight = animalM?.imageHeight1, let imageWidth = animalM?.imageWidth1{
                height = CGFloat(imageHeight / imageWidth * Float(width))
                print(height)
            }else if self.i == 2, let imageHeight = animalM?.imageHeight2, let imageWidth = animalM?.imageWidth2{
                height = CGFloat(imageHeight / imageWidth * Float(width))
            }else if self.i == 3, let imageHeight = animalM?.imageHeight3, let imageWidth = animalM?.imageWidth3{
                height = CGFloat(imageHeight / imageWidth * Float(width))
            }
        case 1:
            if animalM?.name == ""{
                height = 0
            }else{
                if let text = animalM?.name{
                    height = estimateFrameForText(text: text).height + 20
                }
            }
        case 2:
            if animalM?.enName == ""{
                height = 0
            }else{
                if let text = animalM?.enName{
                    height = estimateFrameForText(text: text).height + 20
                }
            }
            
        case 3:
            if animalM?.location == ""{
                height = 0
            }else{
                if let text = animalM?.location{
                    height = estimateFrameForText(text: text).height + 20
                }
            }
            
        case 4:
            if animalM?.distribution == ""{
                height = 0
            }else{
                if let text = animalM?.distribution{
                    height = estimateFrameForText(text: text).height + 50
                }
            }
            
        case 5:
            if animalM?.habitat == ""{
                height = 0
            }else{
                if let text = animalM?.habitat{
                    height = estimateFrameForText(text: text).height + 58
                }
            }
            
        case 6:
            if animalM?.feature == ""{
                height = 0
            }else{
                if let text = animalM?.feature{
                    height = estimateFrameForText(text: text).height + 53
                }
            }
            
        case 7:
            if animalM?.behavior == ""{
                height = 0
                
            }else{
                if let text = animalM?.behavior{
                    height = estimateFrameForText(text: text).height + 60
                }
            }
            
        case 8:
            if animalM?.diet == ""{
                height = 0
            }else{
                if let text = animalM?.diet{
                    height = estimateFrameForText(text: text).height + 50
                }
            }
        case 9:
            if animalM?.interpretation == ""{
                height = 0
            }else{
                if let text = animalM?.interpretation{
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
                if self.animalM?.pic0 == nil , self.animalM?.pic1 == nil , self.animalM?.pic2 == nil , self.animalM?.pic3 == nil {
                    height = 0
                }else if self.i == 0, let imageHeight = self.animalM?.imageHeight0, let imageWidth = self.animalM?.imageWidth0{
                    height = CGFloat(imageHeight / imageWidth * Float(width))
                }else if self.i == 1, let imageHeight = self.animalM?.imageHeight1, let imageWidth = self.animalM?.imageWidth1{
                    height = CGFloat(imageHeight / imageWidth * Float(width))
                    print(height)
                }else if self.i == 2, let imageHeight = self.animalM?.imageHeight2, let imageWidth = self.animalM?.imageWidth2{
                    height = CGFloat(imageHeight / imageWidth * Float(width))
                }else if self.i == 3, let imageHeight = self.animalM?.imageHeight3, let imageWidth = self.animalM?.imageWidth3{
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
