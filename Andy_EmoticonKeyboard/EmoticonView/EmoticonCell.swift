//
//  EmoticonCell.swift
//  Andy_EmoticonKeyboard
//
//  Created by Yue Zhou on 7/25/17.
//  Copyright © 2017 Yue Zhou. All rights reserved.
//

import UIKit

class EmoticonCell: UICollectionViewCell {
    
    var emoticon: Emoticon? {
        didSet {
            // whether it is "Backspace" emoticon. But cannot write it here, because cell reuse issue will happen (setTitle below here may result in a "Backspace" button with emoji together on one emoticon button)
//            if emoticon!.isBackspace {
//                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: UIControlState.normal)
//                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: UIControlState.highlighted)
//                return
//            }
            
            // non-emoji emoticon
            if emoticon!.chs != nil {
                emoticonBtn.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), for: UIControlState.normal)
            }
            else {  // emoji
                emoticonBtn.setImage(nil, for: UIControlState.normal)   // avoid cell reuse issue
            }
            
            emoticonBtn.setTitle(emoticon?.emoji ?? "", for: UIControlState.normal)
            
            // whether it is "Backspace" emoticon
            if emoticon!.isBackspace {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: UIControlState.normal)
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: UIControlState.highlighted)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    
    /// init UI
    private func setupUI() {
        // add and layout
        addSubview(emoticonBtn)
        emoticonBtn.frame = contentView.bounds.insetBy(dx: 4, dy: 4)
        
    }
    
    
    // MARK: lazy init
    private lazy var emoticonBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        btn.addTarget(self, action: #selector(emoticonClicked), for: UIControlEvents.touchUpInside)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    
    // MARK: listeners
    @objc fileprivate func emoticonClicked() {
        print(#function)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
