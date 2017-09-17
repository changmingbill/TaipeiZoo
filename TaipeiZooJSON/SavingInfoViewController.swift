//
//  SavingInfoViewController.swift
//  TaipeiZooJSON
//
//  Created by 張健民 on 2017/9/5.
//  Copyright © 2017年 CliffC. All rights reserved.
//

import UIKit
import CoreData
private let reuseIdentifiers = ["cell_1","cell_2","cell_3","cell_4","cell_5","cell_6","cell_7","cell_8","cell_9","cell_10"]
class SavingInfoViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    var timer: Timer?
    var animalM: AnimalM?
    var imageData = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true //可以維持collectionView顯示保持回彈狀態
        collectionView?.backgroundColor = UIColor.white // view.backgroundColor = UIColor.white這個沒效果
//        collectionView?.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 8, right: 0) //設定collectionView與view間的邊界條件
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
        if let titleName = animalM?.name{
            navigationItem.title = titleName
        }
        for i in 0...9{
            self.collectionView!.register(InformationCell.self, forCellWithReuseIdentifier: reuseIdentifiers[i])
        }
        
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "く", style: .plain, target: self, action: #selector(PopBack))
        
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
        return 0
    }
    

   
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    var scrollView: UIScrollView!
    func setupScrollView(){
        let width = UIScreen.main.bounds.width
        if let imageHeight = animalM?.imageHeight0, let imageWidth = animalM?.imageWidth0{
            let height = CGFloat(imageHeight / imageWidth * Float(width))
            let rect = CGRect(x: 0, y: 0, width: width, height: height)
            scrollView = UIScrollView(frame: rect)
        }
        scrollView.backgroundColor = UIColor.clear
        scrollView.isPagingEnabled = true
        let width0 = UIScreen.main.bounds.width-10
        if animalM?.pic1 != nil{
            scrollView.contentSize = CGSize(width: (width0 + 10)*CGFloat(imageData.count+3), height: scrollView.bounds.height)
        }
        
    }
    
    
    func loadScrollViewWithPage(_ page:Int, _ data:Data) {
        if page < 0 {
            return
            
        }
            let width = UIScreen.main.bounds.width-10
            let imageView = UIImageView(frame: CGRect(x: (width + 10)*CGFloat(page), y: 0, width:width, height:scrollView.bounds.height))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: data)
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
            self.scrollView.addSubview(imageView)
        
    }
    
    func handleZoomTap(tapGesture: UITapGestureRecognizer){
        if let imageView = tapGesture.view as? UIImageView{
            guard imageView.image != nil else{
                return
            }
            performZoomInForStaringImageView(startingImageView: imageView)
        }
        
    }
    
    
    var pageControl: UIPageControl!
    func setupPageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        pageControl.numberOfPages = imageData.count
//        pageControl.currentPageIndicatorTintColor = UIColor(r: 204, g: 255, b: 102)
        pageControl.currentPageIndicatorTintColor = UIColor.yellow
        pageControl.pageIndicatorTintColor = UIColor(r: 192, g: 210, b: 241)
    }
    
    var page = 0

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifiers[indexPath.item], for: indexPath) as! InformationCell
        cell.savingInfoController = self //這行不打無法從其他class控制本地端class的函式
        switch indexPath.item {
        case 0:
            if pageControl == nil {
            
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

            cell.leftTextView.isHidden = true
            cell.rightTextView.isHidden = true
            cell.textView.isHidden = true
            setupScrollView()
            setupzoomingScrollView()
            self.scrollView.delegate = self
            self.zoomingScrollView.delegate = self
            setupPageControl()
            cell.bubbleView.backgroundColor = UIColor.clear
            cell.animalImageView.removeFromSuperview()
            cell.bubbleView.addSubview(scrollView)
            cell.pageControl.addSubview(pageControl)
            
            for i in 1...imageData.count{
                loadScrollViewWithPage(i+1, imageData[i-1] as! Data)
            }
            
            if imageData.count > 1{
                loadScrollViewWithPage(imageData.count+2, imageData[0] as! Data)
                loadScrollViewWithPage(1, imageData[imageData.count-1] as! Data)
               
            }else{
                pageControl.isHidden = true
            }
                scrollView.contentOffset = CGPoint(x: scrollView.frame.width*2, y: 0)
            
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
            
        case 5:
            cell.leftTextView.text = "Habitat : "
            cell.textView.text = animalM?.habitat
        case 6:
            cell.leftTextView.text = "Feature : "
            cell.textView.text = animalM?.feature

            
        case 7:
            cell.leftTextView.text = "Behavior : "
            cell.textView.text = animalM?.behavior
            
        case 8:
            cell.leftTextView.text = "Diet : "
            cell.textView.text = animalM?.diet

            
            
        case 9:
            cell.leftTextView.text = "Interpretation : "
            cell.textView.text = animalM?.interpretation
            
            
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
            }else if self.page == 0, let imageHeight = animalM?.imageHeight0, let imageWidth = animalM?.imageWidth0{
                height = CGFloat(imageHeight / imageWidth * Float(width))
            }else if self.page == 1, let imageHeight = animalM?.imageHeight1, let imageWidth = animalM?.imageWidth1{
                height = CGFloat(imageHeight / imageWidth * Float(width))
                print(height)
            }else if self.page == 2, let imageHeight = animalM?.imageHeight2, let imageWidth = animalM?.imageWidth2{
                height = CGFloat(imageHeight / imageWidth * Float(width))
            }else if self.page == 3, let imageHeight = animalM?.imageHeight3, let imageWidth = animalM?.imageWidth3{
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
                    height = estimateFrameForText(text: text).height + 70
                }
            }
            
        case 6:
            if animalM?.feature == ""{
                height = 0
            }else{
                if let text = animalM?.feature{
                    height = estimateFrameForText(text: text).height + 70
                }
            }
            
        case 7:
            if animalM?.behavior == ""{
                height = 0
                
            }else{
                if let text = animalM?.behavior{
                    height = estimateFrameForText(text: text).height + 70
                }
            }
            
        case 8:
            if animalM?.diet == ""{
                height = 0
            }else{
                if let text = animalM?.diet{
                    height = estimateFrameForText(text: text).height + 70
                }
            }
        case 9:
            if animalM?.interpretation == ""{
                height = 0
            }else{
                if let text = animalM?.interpretation{
                    height = estimateFrameForText(text: text).height + 70
                }
            }
        default:
            break
        }
        
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1500)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin) //使用union可以同時包含兩個屬性:usesFontLeading,usesLineFragmentOrigin
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
    }
    
    // MARK: scrollViewDidScroll
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if imageData.count > 1{
            let i = CGFloat(imageData.count)
            if scrollView.contentOffset.x == (scrollView.frame.width)*(i+2) {//scrollView.contentOffset.x 指的是scrollView.contentSize的x座標
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (timer) in
                    scrollView.contentOffset = CGPoint(x: scrollView.frame.width*2, y: 0)
                })
            }
            if scrollView.contentOffset.x == scrollView.frame.width {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (timer) in
                    scrollView.contentOffset = CGPoint(x: scrollView.frame.width*(i+1), y: 0)
                })
            }
            
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var page = scrollView.currentPage
//        print(page)
        if  page == imageData.count+2{
            page = 2
        }else if page == 1{
            page = imageData.count+1
        }
        pageControl.currentPage = page-2
        self.page = page-2
        
    }
    
    // MARK: Zooming Setting
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIView?
    var pageDic = [Int:UIScrollView]()
    var pageImageViewDic = [Int:UIImageView]()
    var imageView:UIImageView!
    
    var zoomingPageControl: UIPageControl!
    func setupZoomingPageControl(){
        zoomingPageControl = UIPageControl(frame: CGRect(x: UIScreen.main.bounds.width/2-50, y: UIScreen.main.bounds.height-50, width: 100, height: 50))
        zoomingPageControl.numberOfPages = imageData.count
        zoomingPageControl.currentPageIndicatorTintColor = UIColor.yellow
        zoomingPageControl.pageIndicatorTintColor = UIColor.orange
    }

    var zoomingScrollView: UIScrollView!
    func setupzoomingScrollView(){
        self.zoomingScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        zoomingScrollView.isPagingEnabled = true
        zoomingScrollView.backgroundColor = UIColor.clear
        if animalM?.pic1 != nil{
            zoomingScrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width)*CGFloat(imageData.count+3), height:zoomingScrollView.bounds.height)
        }
        
    }

    func loadScrollViewWithZoomingPage(_ page:Int, _ data:Data, _ dataN:Int) {
        if page < 0 {
            return
        }
        else if self.pageDic[page] == nil{
        var height: CGFloat = 300
        let width = UIScreen.main.bounds.size.width
        if self.animalM?.pic0 == nil , self.animalM?.pic1 == nil , self.animalM?.pic2 == nil , self.animalM?.pic3 == nil {
            height = 0
        }else if dataN == 0, let imageHeight = self.animalM?.imageHeight0, let imageWidth = self.animalM?.imageWidth0{
            height = CGFloat(imageHeight / imageWidth * Float(width))
        }else if dataN == 1, let imageHeight = self.animalM?.imageHeight1, let imageWidth = self.animalM?.imageWidth1{
            height = CGFloat(imageHeight / imageWidth * Float(width))
        }else if dataN == 2, let imageHeight = self.animalM?.imageHeight2, let imageWidth = self.animalM?.imageWidth2{
            height = CGFloat(imageHeight / imageWidth * Float(width))
        }else if dataN == 3, let imageHeight = self.animalM?.imageHeight3, let imageWidth = self.animalM?.imageWidth3{
            height = CGFloat(imageHeight / imageWidth * Float(width))
        }

        let scrollView = UIScrollView(frame: CGRect(x: (width)*CGFloat(page), y: UIScreen.main.bounds.height/2-height/2, width: width, height: height))
            scrollView.contentSize = scrollView.bounds.size
            scrollView.delegate = self
            scrollView.layer.cornerRadius = 10
            scrollView.clipsToBounds = true
            scrollView.backgroundColor = UIColor.black
            scrollView.maximumZoomScale = 2
            scrollView.minimumZoomScale = 1
            scrollView.zoomScale = 1
            
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//            imageView = UIImageView(frame: scrollView.frame)
            scrollView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFill//要寫在imageView.image之前，否則會比例會跑掉
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: data)
            scrollView.addSubview(imageView)
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            
            self.pageDic[page] = scrollView
            self.pageImageViewDic[page] = imageView
            self.zoomingScrollView.addSubview(scrollView)
        }
    }
    //MARK: func viewForZooming(in scrollView: UIScrollView)
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return scrollView.subviews.first
    }

    func removeScrollViewWithPage(page:Int) {
        if page < 0{
            return
        }
        else if pageDic[page] != nil, pageImageViewDic != nil
        {
            self.pageDic[page]?.removeFromSuperview()
            self.pageDic[page] = nil
            self.pageImageViewDic[page]?.removeFromSuperview()
            self.pageImageViewDic[page] = nil
        } }
    
    //my custom zooming logic
    func performZoomInForStaringImageView(startingImageView: UIImageView){
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)//取startingImageView size
        setupZoomingPageControl()
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        for i in 1...imageData.count{
            loadScrollViewWithZoomingPage(i+1, imageData[i-1] as! Data, i-1)
        }
        
        if imageData.count > 1{
            loadScrollViewWithZoomingPage(imageData.count+2, imageData[0] as! Data, 0)
            loadScrollViewWithZoomingPage(1, imageData[imageData.count-1] as! Data, imageData.count-1)
            loadScrollViewWithZoomingPage(0, imageData[imageData.count-1] as! Data, imageData.count-1)
            
        }else{
            zoomingPageControl.isHidden = true
        }

        if self.page == 0{
            zoomingScrollView.contentOffset = CGPoint(x: zoomingScrollView.frame.width*2, y: 0)
        }else if page == 1{
            zoomingScrollView.contentOffset = CGPoint(x: zoomingScrollView.frame.width*3, y: 0)
        }else if page == 2{
            zoomingScrollView.contentOffset = CGPoint(x: zoomingScrollView.frame.width*4, y: 0)
        }else if page == 3{
            zoomingScrollView.contentOffset = CGPoint(x: zoomingScrollView.frame.width*5, y: 0)
        }
        
//        let zoomingImageView = UIImageView(frame: startingFrame!)
//        zoomingImageView.backgroundColor = UIColor.clear
//        zoomingImageView.layer.cornerRadius = 10
//        zoomingImageView.clipsToBounds = true
//        zoomingImageView.image = startingImageView.image
//        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
//        zoomingImageView.isUserInteractionEnabled = true
        if let keyWindow = UIApplication.shared.keyWindow{
            keyWindow.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
           

            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0 //開始時會看不見
            zoomingPageControl.alpha = 0
            keyWindow.addSubview(blackBackgroundView!) //這行程式碼在前，所以blackBackgroundView會在zoomingImageView之後呈現
            
            keyWindow.addSubview(zoomingScrollView)
//            keyWindow.addSubview(zoomingPageControl)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1 //從0->1，有動畫漸層效果
                self.zoomingPageControl.alpha = 1
                //math?
                // h2/w2 = h1/w1
                // h2 = h1 / w1 * w2
                var height: CGFloat = 300
                let width = keyWindow.frame.width
                if self.animalM?.pic0 == nil , self.animalM?.pic1 == nil , self.animalM?.pic2 == nil , self.animalM?.pic3 == nil {
                    height = 0
                }else if self.page == 0, let imageHeight = self.animalM?.imageHeight0, let imageWidth = self.animalM?.imageWidth0{
                    height = CGFloat(imageHeight / imageWidth * Float(width))
                }else if self.page == 1, let imageHeight = self.animalM?.imageHeight1, let imageWidth = self.animalM?.imageWidth1{
                    height = CGFloat(imageHeight / imageWidth * Float(width))
                    print(height)
                }else if self.page == 2, let imageHeight = self.animalM?.imageHeight2, let imageWidth = self.animalM?.imageWidth2{
                    height = CGFloat(imageHeight / imageWidth * Float(width))
                }else if self.page == 3, let imageHeight = self.animalM?.imageHeight3, let imageWidth = self.animalM?.imageWidth3{
                    height = CGFloat(imageHeight / imageWidth * Float(width))
                }
                
                //keyWindow是整個app的view
//                zoomingImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)

//                zoomingImageView.center = keyWindow.center
                
                self.zoomingScrollView.center = keyWindow.center
                
                
            }, completion: { (completed) in
                //                zoomOutImageView.removeFromSuperview()
            })
            
            
        }
        
    }
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view{
            
            if self.page == 0{
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.width*2, y: 0)
            }else if self.page == 1{
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.width*3, y: 0)
            }else if self.page == 2{
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.width*4, y: 0)
            }else if self.page == 3{
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.width*5, y: 0)
            }

            //need to animate back out to controller
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                zoomOutImageView.layer.cornerRadius = 10
                zoomOutImageView.clipsToBounds = true
                zoomOutImageView.frame = self.startingFrame!
                
                
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                    self.blackBackgroundView?.alpha = 0
                    self.zoomingPageControl.alpha = 0
                   
                })

            }, completion: { (completed: Bool) in
                self.zoomingScrollView.removeFromSuperview()
                zoomOutImageView.removeFromSuperview()
                for i in 2...self.imageData.count+1{
                    self.removeScrollViewWithPage(page: i)
                }
                self.startingImageView?.isHidden = false
            })
            
        }
    }

}
