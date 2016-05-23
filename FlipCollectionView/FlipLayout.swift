//
//  FlipLayout.swift
//  Animation
//
//  Created by Josscii on 16/5/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

import UIKit

let screenSize = UIScreen.mainScreen().bounds

class FlipLayoutAttributes: UICollectionViewLayoutAttributes {
    var offset: CGFloat = 0.0
    var angle: CGFloat = 0.0
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! FlipLayoutAttributes
        copy.offset = offset
        copy.angle = angle
        return copy
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributtes = object as? FlipLayoutAttributes {
            if( attributtes.offset == offset && attributtes.angle == angle) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class FlipLayout: UICollectionViewLayout {
    
    var collceionViewContentOffsetY: CGFloat {
        return collectionView!.contentOffset.y
    }
    
    var numberOfItems: Int {
        return collectionView!.numberOfItemsInSection(0)
    }
    
    var itemSize: CGSize = CGSize(width: 235, height: 200)
    var itemSpace: CGFloat = 30
    var sectionTop: CGFloat = 180
    
    var cache = [FlipLayoutAttributes]()
    
    override func prepareLayout() {
        
        cache.removeAll(keepCapacity: false)
        
        for i in 0 ..< numberOfItems {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            let layoutAttributes = FlipLayoutAttributes(forCellWithIndexPath: indexPath)
            
            layoutAttributes.frame.size = itemSize
            layoutAttributes.center = collectionView!.center
            layoutAttributes.frame.origin.y = 180 + CGFloat(i) * itemSpace
            
            cache.append(layoutAttributes)
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: screenSize.width, height: screenSize.height * 2 + 180)
    }
    
    var flagOffset:CGFloat = 0
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [FlipLayoutAttributes]()
        
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        for attr in layoutAttributes {
            let offset = attr.frame.origin.y - collceionViewContentOffsetY - 180
            
            if (offset >= 0 && offset <= 30) {
                flagOffset = offset
                break
            }
        }
        
        for attr in layoutAttributes {
            if attr.frame.origin.y <= collceionViewContentOffsetY + 180 {
                
                let scale = (0.5 * (attr.frame.origin.y - collceionViewContentOffsetY) + 180) / 180
                
                var transfrom = CATransform3DIdentity
                
                transfrom = CATransform3DScale(transfrom, scale, 1, 1)
                
                attr.transform3D = transfrom
                
                attr.zIndex = attr.indexPath.row
                
            } else if attr.frame.origin.y > collceionViewContentOffsetY + 180 {
                
                var transfrom = CATransform3DIdentity
                
                transfrom = CATransform3DScale(transfrom, 1.5, 1, 1)
                transfrom = CATransform3DTranslate(transfrom, 0, collceionViewContentOffsetY + 280 - attr.frame.origin.y, 0)
                
                transfrom.m34 = -0.0001
                
                if attr.frame.origin.y - collceionViewContentOffsetY < 210 {
                    let angle = flagOffset/30 * CGFloat(-M_PI)
                    
                    attr.angle = angle
                    
                    transfrom = CATransform3DRotate(transfrom, angle, 1, 0, 0)
                } else {
                    attr.angle = CGFloat(-M_PI)
                    transfrom = CATransform3DRotate(transfrom, CGFloat(-M_PI), 1, 0, 0)
                }
                
                attr.transform3D = transfrom
                
                attr.zIndex = 200 - attr.indexPath.row
                
            }
            
            attr.offset = collceionViewContentOffsetY
        }
        
        return layoutAttributes
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return FlipLayoutAttributes.self
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round((proposedContentOffset.y - 180) / 30)
        let yOffset = 180 + itemIndex * 30
        
        return CGPoint(x: 0, y: yOffset)
    }
}