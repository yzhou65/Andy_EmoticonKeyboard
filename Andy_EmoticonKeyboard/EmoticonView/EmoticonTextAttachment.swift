//
//  EmoticonTextAttachment.swift
//  Andy_EmoticonKeyboard
//
//  Created by Yue Zhou on 7/25/17.
//  Copyright © 2017 Yue Zhou. All rights reserved.
//

import UIKit

class EmoticonTextAttachment: NSTextAttachment {
    
    /// the non-emoji emoticon's chs
    var chs: String?
    
    class func emoticonText(with emoticon: Emoticon, font: UIFont) -> NSAttributedString {
        let attachment = EmoticonTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        
        let s = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: s, height: s)
        
        return NSAttributedString(attachment: attachment)
    }

}
