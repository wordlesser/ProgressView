//
//  ProgressView.swift
//  Path
//
//  Created by Y_CQ on 2017/1/4.
//  Copyright © 2017年 YCQ. All rights reserved.
//

import UIKit
class ProgressView: UIView {
    private var backGroundLayer: CAShapeLayer!
    private var frontFillLayer: CAShapeLayer!
    private var finishLayer: CAShapeLayer!
    private var backGroundBezierPath: UIBezierPath!
    private var frontFillBezierPath: UIBezierPath!
    private var lbContent: UILabel!
    
    var radius: CGFloat = 25
    
    /// 创建进度控件
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - defaultColor: 进度条默认底色
    ///   - progressTrackColor: 进度条颜色
    ///   - backgroundColor: 控件背景色
    init(frame: CGRect, defaultColor: UIColor?=nil, progressTrackColor: UIColor, backgroundColor: UIColor?=nil) {
        super.init(frame: frame)
        self.setUpAnimation(defaultColor: defaultColor, progressTrackColor: progressTrackColor, backgroundColor: backgroundColor)
        self.setupView(progressTrackColor: progressTrackColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /// 设置view
    ///
    /// - Parameter progressTrackColor: 显示进度颜色
    private func setupView(progressTrackColor: UIColor) {
        lbContent = UILabel(frame: self.bounds)
        lbContent.font = UIFont.systemFont(ofSize: radius/2.5)
        self.addSubview(lbContent)
        lbContent.textColor = progressTrackColor
        lbContent.textAlignment = .center
        lbContent.text = "0.0%"
    }
    
    
    /// 动画
    /// 和初始化中变量意义一样
    /// - Parameters:
    ///   - defaultColor: <#defaultColor description#>
    ///   - progressTrackColor: <#progressTrackColor description#>
    ///   - backgroundColor: <#backgroundColor description#>
    private func setUpAnimation(defaultColor: UIColor?=nil, progressTrackColor: UIColor, backgroundColor: UIColor?=nil) {
        radius = self.bounds.size.width/2
        if self.bounds.size.width > self.bounds.size.height {
            radius = self.bounds.size.height/2
        }
        
        backGroundLayer = CAShapeLayer()
        backGroundLayer.fillColor = nil
        backGroundLayer.frame = self.layer.bounds
        backGroundLayer.strokeColor = defaultColor?.cgColor
        backGroundLayer.lineWidth = radius/5-1.5
        backGroundLayer.fillColor = backgroundColor?.cgColor
        
        frontFillLayer = CAShapeLayer()
        frontFillLayer.fillColor = nil
        frontFillLayer.frame = self.layer.bounds
        frontFillLayer.strokeColor = progressTrackColor.cgColor
        frontFillLayer.lineWidth = radius/5
        
        self.layer.addSublayer(backGroundLayer)
        self.layer.addSublayer(frontFillLayer)
        
        let pathCenter = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        backGroundBezierPath = UIBezierPath(arcCenter: pathCenter, radius: radius-0.5, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        backGroundLayer.path = backGroundBezierPath.cgPath
    }
    
    
    /// 设置进度
    ///
    /// - Parameter progressValue: 进度（0--1表示正常，<0表示失败）
    func setProgressValue(progressValue: CGFloat) {
        lbContent.text = "\(progressValue*100)%"
        let pathCenter = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        frontFillBezierPath = UIBezierPath(arcCenter: pathCenter, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI*2)*progressValue, clockwise: true)
        print(progressValue)
        frontFillLayer.path = frontFillBezierPath.cgPath
        frontFillLayer.lineCap = "round"
        frontFillLayer.lineJoin = "round"
        if progressValue >= 1.0 {
            self.finish(ok: true)
        }
        if progressValue < 0 {
            self.finish(ok: false)
        }
    }
    
    
    /// 进度完成
    ///
    /// - Parameter ok: 是否成功
    private func finish(ok: Bool?=true) {
        self.lbContent.removeFromSuperview()
        
        var duration = 0.2
        var strokeColor = frontFillLayer.strokeColor
        let finishPath = UIBezierPath()
        if ok == true {
            let startPoint = CGPoint(x: self.bounds.width/5, y: self.bounds.height/6*3)
            finishPath.move(to: startPoint)
            let centerPoint = CGPoint(x: self.bounds.width/7*3, y: self.bounds.height/3*2.2)
            finishPath.addLine(to: centerPoint)
            let lastPoint = CGPoint(x: self.bounds.width/5*4, y: self.bounds.height/3*0.9)
            finishPath.addLine(to: lastPoint)
        }else {
            duration = 0.4
            strokeColor = backGroundLayer.strokeColor
            
            self.frontFillLayer.removeFromSuperlayer()
            self.frontFillLayer.path = nil
            
            let startPoint1 = CGPoint(x: self.bounds.width/4, y: self.bounds.height/4)
            finishPath.move(to: startPoint1)
            let lastPoint1 = CGPoint(x: self.bounds.width/4*3, y: self.bounds.height/4*3)
            finishPath.addLine(to: lastPoint1)
            
            let finishPath1 = UIBezierPath()
            let startPoint2 = CGPoint(x: self.bounds.width/4*3, y: self.bounds.height/4)
            finishPath1.move(to: startPoint2)
            let lastPoint2 = CGPoint(x: self.bounds.width/4, y: self.bounds.height/4*3)
            finishPath1.addLine(to: lastPoint2)
            finishPath.append(finishPath1)
        }
        
        finishLayer = CAShapeLayer()
        finishLayer.fillColor = nil
        finishLayer.frame = self.layer.bounds
        finishLayer.lineWidth = radius/7
        finishLayer.fillColor = UIColor.clear.cgColor
        finishLayer.strokeColor = strokeColor
        finishLayer.path = finishPath.cgPath
        finishLayer.lineJoin = "round"
        finishLayer.lineJoin = "round"
        self.layer.addSublayer(finishLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        finishLayer.add(animation, forKey: "")
    }
    
    
    private func reset() {
        self.addSubview(lbContent)
        frontFillLayer.removeFromSuperlayer()
        frontFillLayer.path = nil
        self.layer.addSublayer(self.frontFillLayer)
        
        finishLayer?.removeAllAnimations()
        finishLayer?.removeFromSuperlayer()
        finishLayer = nil
    }
    
    
    /// 复位操作
    func reStart() {
        self.reset()
    }
    
}
