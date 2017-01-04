//
//  ViewController.swift
//  Path
//
//  Created by Y_CQ on 2016/12/29.
//  Copyright © 2016年 YCQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var mv: ProgressView!
    var timer: Timer!
    var i: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        mv = ProgressView(frame: CGRect(x: 50, y: 50, width: 50, height: 50), defaultColor: UIColor.red, progressTrackColor: UIColor.green, backgroundColor: UIColor.white)
        self.view.addSubview(mv)
        self.setTime()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        mv.addGestureRecognizer(tap)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTap() {
        i = 0
        self.mv.reStart()
        self.setTime()
    }
    
    func setTime() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerStart), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func timerStart(timer: Timer) {
//        失败样例
//        mv.setProgressValue(progressValue: -1)
//        return
        if i/5.0 > 1 {
            timer.invalidate()
            timer.fireDate = Date.distantFuture
            self.timer = nil
            return
        }
        mv.setProgressValue(progressValue: i/5.0)
        i+=0.25
    }

    
}


