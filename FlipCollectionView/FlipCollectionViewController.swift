//
//  FlipCollectionViewController.swift
//  Animation
//
//  Created by Josscii on 16/5/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

import UIKit

class FlipCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flipLayout = FlipLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flipLayout)
        collectionView?.registerClass(FlipCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 26
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! FlipCollectionViewCell
        
        cell.imageView?.image = UIImage(named: "\(indexPath.row)")
        
        return cell
    }
}
