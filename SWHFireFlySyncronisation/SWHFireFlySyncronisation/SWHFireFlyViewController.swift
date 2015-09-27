//
//  ViewController.swift
//  SWHFireFlySyncronisation
//
//  Created by Simon J Whitehouse on 27/09/2015.
//  Copyright © 2015 co.swhitehouse. All rights reserved.
//

import UIKit

class SWHFireFlyViewController: UIViewController {
    
    var flies = [SWHFlyView]()
    
    static let NumberOfFlysPerRow = 10
    
    @IBOutlet weak var flyContainer: UIView! {
        didSet {
            flyContainer.layer.borderColor = UIColor.whiteColor().CGColor
            flyContainer.layer.borderWidth = 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        buildFlies()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildFlies() {
        var startOriginX: CGFloat = 0.0
        var startOriginY: CGFloat = 0.0
        
        let flyHeight = ((UIScreen.mainScreen().bounds.size.width - 40) - CGFloat((SWHFireFlyViewController.NumberOfFlysPerRow - 1) * 5)) / CGFloat(SWHFireFlyViewController.NumberOfFlysPerRow)
        
        for var y = 0; y < SWHFireFlyViewController.NumberOfFlysPerRow; y++ {
            for var x = 0; x < SWHFireFlyViewController.NumberOfFlysPerRow; x++ {
                let newFly = SWHFlyView(frame: CGRectMake(startOriginX, startOriginY, flyHeight, flyHeight))
                flyContainer.addSubview(newFly)
                newFly.configure()
                startOriginX += flyHeight + 5
            }
            startOriginX = 0
            startOriginY += flyHeight + 5
        }
    }
    
}

class SWHFlyView : UIView {
    var flashTimer: NSTimer?
    
    var ellapsedTimer: NSTimeInterval = 0.0 {
        didSet {
            if ellapsedTimer >= 9.9 {
                flash()
            }
        }
    }
    
    func configure() {
        backgroundColor = UIColor.yellowColor()
        alpha = 0
        
        ellapsedTimer += (9 - 0) * Double(Double(arc4random()) / Double(UInt32.max)) + 0
        
        flashTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerTicked:", userInfo: nil, repeats: true)
    }
    
    func timerTicked(timer: NSTimer) {
        ellapsedTimer += timer.timeInterval
    }
    
    func flash() {
        UIView.animateKeyframesWithDuration(0.1, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.alpha = 1
            }) { (finish) -> Void in
                self.alpha = 0
                self.resetTimer()
        }
    }
    
    func resetTimer() {
        flashTimer?.invalidate()
        ellapsedTimer = 0.0
        flashTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerTicked:", userInfo: nil, repeats: true)
    }
}
