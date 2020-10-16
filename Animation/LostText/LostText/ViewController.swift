//
//  ViewController.swift
//  LostText
//
//  Created by Sergey on 28.09.2020.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var animationWidth: NSLayoutConstraint!
    @IBOutlet weak var animationHeight: NSLayoutConstraint!
    
    @IBOutlet var animationText: NSTextView!
    @IBOutlet weak var animationView: AnimationView!
    
    
    @IBAction func startButton(_ sender: Any) {
        
        guard let text = animationText.textStorage?.string,
              let animationReader = AnimationReader(text: text) else {
            let alert = NSAlert.init()
            alert.messageText = "Can't read this, sorry..."
            alert.addButton(withTitle: "understandable")
            alert.runModal()
            return
        }
        
        animationWidth.constant = CGFloat(animationReader.canvasWidth)
        animationHeight.constant = CGFloat(animationReader.canvasHeight)
        animationHeight.isActive = true
        animationWidth.isActive = true
        
        animationView.animationReader = animationReader
        
        animationView.needsLayout = true
    }
    

}

