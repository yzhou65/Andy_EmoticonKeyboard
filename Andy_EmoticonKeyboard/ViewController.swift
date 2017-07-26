//
//  ViewController.swift
//  Andy_EmoticonKeyboard
//
//  Created by Yue Zhou on 7/25/17.
//  Copyright © 2017 Yue Zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func postClick(_ sender: UIBarButtonItem) {
//        print(#function)
        print(customTextView.getEmoticonAttributedText())
    }
    
    @IBOutlet weak var customTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(emoticonVC)
        
        customTextView.inputView = emoticonVC.view
        
//        print(EmoticonPackage.emoticonsBundlePath())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customTextView.becomeFirstResponder()
    }

    // MARK: lazy init
    private lazy var emoticonVC: EmoticonViewController = EmoticonViewController { [unowned self] (emoticon) in
        
        // TODO: cannot yet dynamically get the texts' font as the argument, for now just use hard-coded value '20'
        self.customTextView.insertEmoticon(emoticon: emoticon, font: 20)
    }
 
    
    deinit {
        print(#function)
    }
}

