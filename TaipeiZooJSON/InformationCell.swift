//
//  InformationCell.swift
//  TaipeiZooJSON
//
//  Created by 張健民 on 2017/8/25.
//  Copyright © 2017年 CliffC. All rights reserved.
//

import UIKit

class InformationCell: UICollectionViewCell {
//    var chatLogController: ChatLogController?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = ""
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear //要把textView顏色處理掉才能看到bubbleView
        tv.textColor = UIColor.white
        tv.isEditable = false
        //tv.backgroundColor = UIColor.yellow //先著色來觀察顯示的階層在上還是下
        return tv
    }()
    
    let leftTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.isEditable = false
        return tv
    }()
    
    let rightTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.isEditable = false
        return tv
    }()
    //static只能用ChatMessageCell.blueColor來使用，不能用其他類別名稱，例:cell.blueColor
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let bubbleView: UIView = {
        let view  = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var animalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true //決定使用者事件是否會被忽略以及在事件執行緒中是否會被移除，沒有這行tap無反應
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        return imageView
    }()
    //這個方法主要的目的是要得到messgeImageView，轉換給chatLogController
    func handleZoomTap(tapGesture: UITapGestureRecognizer){
        if (tapGesture.view as? UIImageView) != nil{//imageView表被觸到的imageView
            //PRO Tip: don't perform a lot of custom logic inside of a view class
//            self.chatLogController?.performZoomInForStaringImageView(startingImageView: imageView)
        }
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var leftTextViewWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        bubbleView.addSubview(animalImageView)
        addSubview(leftTextView)
        addSubview(textView)
        addSubview(rightTextView)
        addSubview(profileImageView)
        let screenWidth = UIScreen.main.bounds.width
        
        //x,y,w,h
        animalImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        animalImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        animalImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        animalImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        //x,y,w,h
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        //x,y,w,h
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -8)
        //        bubbleViewLeftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: screenWidth-16)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //x,y,w,h
        leftTextView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        leftTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        leftTextViewWidthAnchor = leftTextView.widthAnchor.constraint(equalToConstant: 120)
        leftTextViewWidthAnchor?.isActive = true
        leftTextView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        //x,y,w,h
        rightTextView.leftAnchor.constraint(equalTo: leftTextView.rightAnchor, constant: 0).isActive = true
        rightTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        rightTextView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        rightTextView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        //x,y,w,h
        //        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: leftTextView.bottomAnchor).isActive = true
        //        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
//        textView.heightAnchor.constraint(equalToConstant: self.frame.height-26).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
