//
//  UITextView+EmoticonExtension.swift
//  Andy_EmoticonKeyboard
//
//  Created by Yue Zhou on 7/25/17.
//  Copyright © 2017 Yue Zhou. All rights reserved.
//

import UIKit

extension UITextView {
    
    /**
     * Insert an emoticon in the textView
     */
    func insertEmoticon(emoticon: Emoticon) {
        if emoticon.isBackspace {
            deleteBackward()
        }
        
        if emoticon.emoji != nil {
            replace(selectedTextRange!, withText: emoticon.emoji!)
        }
        
        if emoticon.png != nil {
            // create the emoticon text
            let imageText = EmoticonTextAttachment.emoticonText(with: emoticon, font: font!)
            
            let maString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
            let range: NSRange = selectedRange
            
            // replace the selected range with imageText
            maString.replaceCharacters(in: range, with: imageText)
            
            // AttributedString has its default font. Here the font has to be set, otherwise ensuing emoticons will change fonts.
            maString.addAttribute(NSFontAttributeName, value: font!, range: NSRange.init(location: range.location, length: 1))
            
            // replaced AttributedString -> UITextView
            attributedText = maString
            
            // put the cursor to the right location
            selectedRange = NSRange.init(location: range.location + 1, length: 0)   // range.location: cursor's location
            
            // voluntarily call "textViewDidChange" method (input of non-emoji emoticon will not call this method. If outside has to spy on textViewDidChange, delegate.textViewDidChange has to be called inside here）
            delegate?.textViewDidChange!(self)
        }
    }
    
    
    
    /**
     * Get the attributedString in the textView and be ready to post it to the server
     */
    func getEmoticonAttributedText() -> String {
        var strM = ""
        
        // traverse the attributedString
        attributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length), options: NSAttributedString.EnumerationOptions.init(rawValue: 0)) { (dict, range, _) in
            /**
             * range: the range of pure String (not attributedString)
             if there is emoticon in-between pure String, range will be multiple values
             dict: a dictionary, if value of key "NSAttachment" is not nil, the current iteration is an emoticon
             */
            if dict["NSAttachment"] != nil {    // image
                let attachment = dict["NSAttachment"] as! EmoticonTextAttachment
                strM += attachment.chs!
            }
            else {  // pure String
                strM += (self.text as NSString).substring(with: range)
            }
        }
        return strM
    }
    
}
