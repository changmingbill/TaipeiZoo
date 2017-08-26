//
//  UserCell.swift
//  gameofchats
//
//  Created by 張健民 on 2017/8/13.
//  Copyright © 2017年 CliffC. All rights reserved.
//

import UIKit
import Firebase
class UserCell: UITableViewCell {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    
    
    
    let animalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Panda")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        //imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
//        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.addSubview(animalImageView)
        self.addSubview(timeLabel)
        
        //iso 9 constraint anchor
        //need x,y,width,height anchors
        animalImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        
        animalImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        
        animalImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        animalImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        //need x,y,width,height anchors
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

