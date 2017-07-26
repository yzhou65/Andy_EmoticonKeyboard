//
//  EmoticonViewController.swift
//  Andy_EmoticonKeyboard
//
//  Created by Yue Zhou on 7/25/17.
//  Copyright © 2017 Yue Zhou. All rights reserved.
//

import UIKit

let AndyEmoticonCellReuseIdentifier = "AndyEmoticonCellReuseIdentifier"

class EmoticonViewController: UIViewController {
    
    /// the closure is to store the emoticon selected
    var didSelectEmoticon: ((_ emoticon: Emoticon)->())
    
    init(didSelectEmoticon: @escaping ((_ emoticon: Emoticon)->())) {
        self.didSelectEmoticon = didSelectEmoticon
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red    // for debugging
        
        // init UI
        setupUI()
    }
    
    
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(toolbar)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let dict = ["collectionView" : collectionView, "toolbar" :toolbar] as [String : Any]
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolbar]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dict)
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-[toolbar(44)]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dict)
        
        view.addConstraints(cons)
    }

    
    
    // MARK: lazy init
    /// emoticons' collectionView
    private lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionLayout())
        clv.register(EmoticonCell.self, forCellWithReuseIdentifier: AndyEmoticonCellReuseIdentifier)
        clv.dataSource = self
        clv.delegate = self
        return clv
    }()

    /// toolbar underbeneath the emoticons' collectionView
    private lazy var toolbar: UIToolbar = {
        let bar = UIToolbar()
        bar.tintColor = UIColor.darkGray
        
        var emoticonNameItems = [UIBarButtonItem]()
        var index = 0
        for title in ["Recent", "Default", "Emoji", "Lxh"] {
            let item: UIBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(itemClicked))
            item.tag = index
            index += 1
            
            emoticonNameItems.append(item)
            
            // add additional whitespace after each item
            emoticonNameItems.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
        }
        emoticonNameItems.removeLast()  // remove the last whitespace
        
        bar.items = emoticonNameItems
        return bar
    }()
    
    
    /// emoticons' data
    fileprivate lazy var packages: [EmoticonPackage] = EmoticonPackage.getPackages()
    
    
    // MARK: listeners
    @objc fileprivate func itemClicked(item: UIBarButtonItem) {
//        print("EmoticonGroup: \(item.tag)")
        collectionView.scrollToItem(at: IndexPath(item: 0, section: item.tag), at: UICollectionViewScrollPosition.left, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: UICollectionViewDataSource
extension EmoticonViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("refreshing: \(indexPath.section)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AndyEmoticonCellReuseIdentifier, for: indexPath) as! EmoticonCell
        cell.backgroundColor = (indexPath.item % 2 == 0 ? UIColor.red : UIColor.green)
        
        let package = packages[indexPath.section]
        cell.emoticon = package.emoticons[indexPath.item]
        
        return cell
    }
}


// MARK: UICollectionViewDelegate
extension EmoticonViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Select item \(indexPath.section), \(indexPath.item)")
        let emoticon = packages[indexPath.section].emoticons[indexPath.item]    // get the emoticon selected
        
        // if whitespace is selected, no need to do anything
        if emoticon.code == nil && emoticon.chs == nil {
            return
        }
        
        // emoticon's frequency increments
        emoticon.freq += 1
        packages[0].appendRecentEmoticon(emoticon)  //  add the emoticon clicked into "Recent" group
        
        // reload data of "Recent" group which is Section 0
        collectionView.reloadSections(IndexSet.init(integer: IndexSet.Element()))
        
        // display the emoticon
        didSelectEmoticon(emoticon)
    }
}


class EmoticonCollectionLayout: UICollectionViewFlowLayout {
    override func prepare() {
        // customizes the cell
        let width = collectionView!.bounds.width / 7
        itemSize = CGSize(width: width, height: width)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        // customizes collectionView
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        // set the inset of top and bottom
        let inset = (collectionView!.bounds.height - 3 * width) * 0.48
        collectionView?.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }
}
