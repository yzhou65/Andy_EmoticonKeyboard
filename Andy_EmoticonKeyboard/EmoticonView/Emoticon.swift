//
//  Emoticon.swift
//  Andy_EmoticonKeyboard
//
//  Created by Yue Zhou on 7/25/17.
//  Copyright © 2017 Yue Zhou. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    
    /// the emoticon's text representation
    var chs: String?
    
    /// the emoticon's image name
    var png: String? {
        didSet {
            imagePath = ((EmoticonsBundleRootPath as NSString).appendingPathComponent(id!) as NSString).appendingPathComponent(png!)
        }
    }
    
    /// the emoticon image's full path
    /**
     * emoticon image's full path
     */
    var imagePath: String?
    
    /// emoji's hex code
    var code: String? {
        didSet {
            let scanner = Scanner(string: code!)
            var hex: UInt32 = 0
            scanner.scanHexInt32(&hex)
            emoji = "\(Character.init(UnicodeScalar.init(hex)!))"
        }
    }
    
    /// emoji emoticon represented by String
    var emoji: String?
    
    /// emoticon's id
    var id: String?
    
    /// whether the emoticon is a "backspace" button
    var isBackspace: Bool = false
    
    /// frequency
    var freq: Int = 0
    
    init(isBackspace: Bool) {
        super.init()
        self.isBackspace = isBackspace
    }
    
    init(dict: [String: String], id: String) {
        super.init()
        
        self.id = id
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
