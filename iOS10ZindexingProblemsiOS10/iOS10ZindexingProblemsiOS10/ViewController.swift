//
//  ViewController.swift
//  iOS10ZindexingProblemsiOS10
//
//  Created by Krzysztof Profic on 28.09.2016.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate let ds = MyDataSource()
    fileprivate let flow = MyLayout()   // just a Flow layout, I'm only overriding collectionViewContentSize to make it scrollable while having one cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flow.headerReferenceSize = CGSize(width: 100, height: 50)
        flow.sectionHeadersPinToVisibleBounds = true
        flow.itemSize = CGSize(width: 100, height: 100)
        
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: flow)
        cv.dataSource = ds
        view.addSubview(cv)
        ds.registerReusableViews(cv)
        
        // the problem is when we have two collectionView subviews one on top of each other
        // in this case we scroll programmatically the content so the cell is underneath the section header
        // but one could do that by just interacting with the collection view and scrolling
        cv.setContentOffset(CGPoint(x: 0, y:20), animated: true)
        
        // then we start refreshing the content
        //
        // first section reload is ok (even though the cell appears on top of the header during reload the final state is fine - header stays above the cell)
        delay(2) {
            cv.reloadSections(IndexSet(integer: 0))
        }
        
        // the second reload breaks the zIndexing. Once the reload is finished our section header goes behind the cell
        // this is only an issue on iOS 10, and it is also an issue if we have our custom layout with supplementaryViews hehaving like section headers (and manually adjusting zindexes using layoutAttributes).
        delay(4) {
            cv.reloadSections(IndexSet(integer: 0))
        }
    }
}


func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
