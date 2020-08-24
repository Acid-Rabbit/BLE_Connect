//
//  ViewController.swift
//  BLE_Connect
//
//  Created by 服部　翼 on 2020/06/27.
//  Copyright © 2020 服部　翼. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController {
    
    @IBOutlet weak var reScanButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var messageLableArray: [UILabel]!
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var messageUnderView: UIView!
    @IBOutlet weak var messageUnderViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scanStopUnderView: UIView!
    @IBOutlet weak var scanStopButton: UIButton! {
        didSet {
            scanStopButton.layer.cornerRadius = scanStopButton.frame.width / 2
        }
    }
    @IBOutlet weak var indicator: NVActivityIndicatorView! {
        didSet {
            indicator.type = .ballScaleMultiple
            indicator.color = .mainColor
        }
    }
    
    private let animateDuration = 0.5
    private var messageAnimationDuration = 0.5
    private var loopCount = 0
    private var stopAnimation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        indicator.startAnimating()
        startAnimation(index: self.loopCount)
    }
    
    
    @IBAction func tappedReScanButton(_ sender: Any) {
        self.reScanButton.isEnabled = false
        self.messageUnderView.isHidden = false
        self.scanStopUnderView.isHidden = false
        
        UIView.animate(withDuration: animateDuration, animations: {
            self.messageUnderViewHeight.constant = 40
            self.scanStopUnderView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (completion) in
            self.indicator.startAnimating()
        }
    }
    
    @IBAction func tappedScanStopButton(_ sender: Any) {
        indicator.stopAnimating()
        
        UIView.animate(withDuration: animateDuration ,animations: {
            self.messageUnderViewHeight.constant = 0
            self.scanStopUnderView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (completion) in
            self.messageUnderView.isHidden = true
            self.scanStopUnderView.isHidden = true
            self.reScanButton.isEnabled = true
        }
    }
}

extension ViewController: CAAnimationDelegate {
    
    func startAnimation(index: Int) {
        let y = messageStackView.frame.origin.y + 6
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = messageAnimationDuration
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = y
        animation.byValue = y + 1
        animation.toValue = y + 6
        
        animationGroup.animations = [animation]
        animationGroup.delegate = self
        messageLableArray[index].layer.add(animationGroup, forKey: nil)
    }
    
    
    
    func animationDidStart(_ anim: CAAnimation) {
        loopCount += 1
        if loopCount == messageLableArray.count {
            loopCount = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.startAnimation(index: self.loopCount)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    }
}
