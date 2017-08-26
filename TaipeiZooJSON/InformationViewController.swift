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
    
    var animal:Animal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true //可以維持collectionView顯示保持回彈狀態
        collectionView?.backgroundColor = UIColor.white // view.backgroundColor = UIColor.white這個沒效果
        
        self.collectionView!.register(InformationCell.self, forCellWithReuseIdentifier: reuseIdentifier)

       
    }

    
    func fetchAnimal(animal: Animal){
        
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

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 8
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InformationCell
        switch indexPath.row {
            
        case 0:
            if let urlString = animal?.pic01Url{
                cell.messgeImageView.loadImageUsingCacheWithUrlString(urlString: urlString)
            }
        case 1:
            cell.textView.text = animal?.name
        case 2:
            cell.textView.text = animal?.enName
        case 3:
            cell.textView.text = animal?.location
        case 4:
            cell.textView.text = animal?.distribution
        case 5:
            cell.textView.text = animal?.behavior
        case 6:
            cell.textView.text = animal?.diet
        case 7:
            cell.textView.text = animal?.interpretation

        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        // get estimated height somehow???
//        let message = messages[indexPath.item]
//        if let text = message.text{
//            height = estimateFrameForText(text: text).height + 20
//        }else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue{
//            // h1 / w1 = h2 / w2
//            // solve for h1
//            // h1 = h2 / w2 * w1
//            height = CGFloat(imageHeight / imageWidth * 200)
//        }
        
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
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
