//
//  AnimationLabelView.swift
//  BLE_Connect
//
//  Created by 服部　翼 on 2020/06/27.
//  Copyright © 2020 服部　翼. All rights reserved.
//

import UIKit

class AnimationlabelView: UIView {
    
    var title: String = ""
    var charMargin: CGFloat = 1
    var textColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
    var animateDuration: Double = 0.5
    var labelRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    
    private var loopCount: Int = 0
    private var labelArray : [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        var startx : CGFloat = labelRect.origin.x
        for i in self.title {
            let label = UILabel()
            label.text = String(i)
            label.textColor = self.textColor
            label.sizeToFit()
            label.frame.origin.x = startx
            startx += label.frame.width + self.charMargin
            label.frame.origin.y = labelRect.origin.y
            self.addSubview(label)
            self.labelArray.append(label)
            print(i,startx,label.frame.width)
        }
    }
    
    func startAnimation(index: Int) {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = animateDuration
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = labelRect.origin.y + 6
        animation.byValue = labelRect.origin.y + 1
        animation.toValue = labelRect.origin.y
        
        let animation2 = CABasicAnimation(keyPath: "position.y")
        animation2.fromValue = labelRect.origin.y
        animation2.byValue = labelRect.origin.y + 5
        animation2.toValue = labelRect.origin.y + 6
        
        animationGroup.animations = [animation, animation2]
        animationGroup.delegate = self
        labelArray[index].layer.add(animationGroup, forKey: nil)
    }
}


extension AnimationlabelView: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        loopCount += 1
        if loopCount == labelArray.count {
            loopCount = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.startAnimation(index: self.loopCount)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    }
}
