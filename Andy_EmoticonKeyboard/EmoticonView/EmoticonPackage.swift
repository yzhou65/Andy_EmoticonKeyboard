//
//  EmoticonPackage.swift
//  Andy_EmoticonKeyboard
//
//  Created by Yue Zhou on 7/25/17.
//  Copyright © 2017 Yue Zhou. All rights reserved.
//

import UIKit

/**
 * Emoticons.bundle's structure：
 1. load emoticon.plist under Emoticons.bundle's root directory
 emoticon.plist -> array of all emoticons（dictionary）
 |--------packages(dict array)
 |--------- id (one group of emoticons' folder name)
 

 2. load a group's info.plist based on path
 info.plist（dictionary）
 |-----id（the current group's folder name）
 |-----group_name_cn（group name）
 |-----emoticons (dict array: all emoticons' attributes)
 |-----chs（a emoticon's text represented by String）
 |-----png（a emoticon's image name represented by String）
 |-----code（emoji's hex code）
 
 */

let EmoticonsBundleRootPath = (Bundle.main.bundlePath as NSString).appendingPathComponent("Emoticons.bundle")

/// One group of emoticons
class EmoticonPackage: NSObject {

    var id: String?
    
    var group_name_cn: String?
    
    var emoticons: [Emoticon] = [Emoticon]()
    
    init(id: String) {
        super.init()
        self.id = id
    }
    
    
    /// get all groups of emoticons
    class func getPackages() -> [EmoticonPackage] {
        var packages = [EmoticonPackage]()
        
        // add "Recent" group ahead of the others
        let pk = EmoticonPackage(id: "")
        pk.group_name_cn = "Recent"
        pk.emoticons = [Emoticon]()
        pk.appendEmptyEmoticons()
        packages.append(pk)
        
        
        // load file "emoticons.plist"
        let emoticonPlistPath = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        let emoticonPlistDict = NSDictionary(contentsOfFile: emoticonPlistPath)!
        let dictArray = emoticonPlistDict["packages"] as! [[String : AnyObject]]
        
        // traverse dictArray
        for dict in dictArray {
            let package = EmoticonPackage(id: dict["id"] as! String)
            packages.append(package)
            package.loadEmoticons()
        
            package.appendEmptyEmoticons()
        }
        return packages
    }
    
    
    /* load Emoticons
     */
    private func loadEmoticons() {
        let emoticonDict = NSDictionary(contentsOfFile: infoPlistPath(name: "info.plist"))!  // load the info.plist from one group
        group_name_cn = emoticonDict["group_name_cn"] as? String
        
        let dictArray = emoticonDict["emoticons"] as! [[String : String]]
//        emoticons = [Emoticon]()
        
        // traverse dictArray
        var idx = 0
        for dict in dictArray {
            if idx == 20 {      // every page has a "Backspace" emoticon at index 20 (every page has 21 emoticons)
                emoticons.append(Emoticon(isBackspace: true))
                idx = 0
            }
            emoticons.append(Emoticon(dict: dict, id: id!))
            idx += 1
        }
    }
    
    
    /// Append empty emoticons whilst there are not enough emoticons in a full page
    func appendEmptyEmoticons() {
        let count = emoticons.count % 21
        for _ in count..<20 {
            emoticons.append(Emoticon(isBackspace: false))
        }
        emoticons.append(Emoticon(isBackspace: true))
    }
    
    
    /// Append an emoticon to the group "Recent"
    func appendRecentEmoticon(_ emoticon: Emoticon) {
        if emoticon.isBackspace {
            return
        }
        
        let contains: Bool = emoticons.contains(emoticon)
        if !contains {
            emoticons.removeLast()  // remove the last one, i.e. the "Backspace" button
            emoticons.append(emoticon)
        }
        
        // sort emoticons in "Recent" by their freq
        var sortedEmoticons = emoticons.sorted { (e1: Emoticon, e2: Emoticon) -> Bool in
            return e1.freq > e2.freq
        }
        
        if !contains {
            sortedEmoticons.removeLast()    // remove the last whitespace
            sortedEmoticons.append(Emoticon(isBackspace: true)) // append the "Backspace" at the back of the group page
        }
        emoticons = sortedEmoticons
    }
    
    
    /// Returns an emoticon's full directory path
    private func infoPlistPath(name: String) -> String {
        return ((EmoticonsBundleRootPath as NSString).appendingPathComponent(id!) as NSString).appendingPathComponent(name)
    }
    
    
//    class func emoticonsBundleRootPath() -> String {
//        return (Bundle.main.bundlePath as NSString).appendingPathComponent("Emoticons.bundle")
//    }
}

