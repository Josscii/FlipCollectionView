//
//  FlipCollectionViewCell.swift
//  FlipCollectionView
//
//  Created by Josscii on 16/5/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

import UIKit

class FlipCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 3
        
        backgroundColor = UIColor.blackColor()
        
        imageView = UIImageView()
        imageView?.contentMode = .ScaleAspectFill
        imageView?.clipsToBounds = true
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView!)
        
        imageView?.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        imageView?.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        imageView?.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true
        imageView?.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let attr = layoutAttributes as! FlipLayoutAttributes
        
        if attr.angle < CGFloat(-M_PI_2) {
            imageView?.hidden = true
            backgroundColor = UIColor(red: 52/255, green: 50/255, blue: 60/255, alpha: 1)
            layer.borderWidth = 0
            if attr.angle == CGFloat(-M_PI) {
                backgroundColor = UIColor.blackColor()
            }
        } else {
            imageView?.hidden = false
            layer.borderWidth = 3
        }
        
        if attr.frame.origin.y > attr.offset + 180 {
            layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        } else {
            layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
    }
}
