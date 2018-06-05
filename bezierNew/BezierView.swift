//
//  BezierView.swift
//  bezierNew
//
//  Created by Елена Сермягина on 04.06.2018.
//  Copyright © 2018 Елена Сермягина. All rights reserved.
//

import UIKit
import Foundation

protocol BezierViewDataSource: class {
    func bezierViewDataPoints(bezierView: BezierView) -> [CGPoint]
}

class BezierView: UIView {

    private let kStrokeAnimationKey = "StrokeAnimationKey"
    private let kFadeAnimationKey = "FadeAnimationKey"
    
    //MARK: Public members
    weak var dataSource: BezierViewDataSource?
    
    var lineColor = UIColor(red: 34.0/255.0, green: 211.0/255.0, blue: 120.0/255.0, alpha: 1.0)
    
    var animates = true
    
    var pointLayers = [CAShapeLayer]()
    var lineLayer = CAShapeLayer()
    
    //MARK: Private members
    
    private var dataPoints: [CGPoint]? {
        return self.dataSource?.bezierViewDataPoints(bezierView: self)
    }
    
    private let cubicCurveAlgorithm = CubicCurveAlgorithm()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.sublayers?.forEach({ (layer: CALayer) -> () in
            layer.removeFromSuperlayer()
        })
        pointLayers.removeAll()
        
        drawSmoothLines()
        drawPoints()
        
        animateLayers()
    }
    
    private func drawPoints(){
        
        guard let points = dataPoints else {
            return
        }
        
        for point in points {
            
            let circleLayer = CAShapeLayer()
            circleLayer.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
            circleLayer.path = UIBezierPath(ovalIn: circleLayer.bounds).cgPath
            circleLayer.fillColor = UIColor(white: 248.0/255.0, alpha: 0.5).cgColor
            circleLayer.position = point
            
            circleLayer.shadowColor = UIColor.black.cgColor
            circleLayer.shadowOffset = CGSize(width: 0, height: 2)
            circleLayer.shadowOpacity = 0.7
            circleLayer.shadowRadius = 3.0
            
            self.layer.addSublayer(circleLayer)
            
            if animates {
                circleLayer.opacity = 0
                pointLayers.append(circleLayer)
            }
        }
    }
    
    private func drawSmoothLines() {
        
        guard let points = dataPoints else {
            return
        }
        
        let controlPoints = cubicCurveAlgorithm.controlPointsFromPoints(dataPoints: points)
        
        
        let linePath = UIBezierPath()
        
        for i in 0..<points.count {
            
            let point = points[i];
            
            if i==0 {
                linePath.move(to: point)
            } else {
                let segment = controlPoints[i-1]
                linePath.addCurve(to: point, controlPoint1: segment.controlPoint1, controlPoint2: segment.controlPoint2)
            }
        }
        
        lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.lineWidth = 4.0
        
        lineLayer.shadowColor = UIColor.black.cgColor
        lineLayer.shadowOffset = CGSize(width: 0, height: 8)
        lineLayer.shadowOpacity = 0.5
        lineLayer.shadowRadius = 6.0
        
        self.layer.addSublayer(lineLayer)
        
        if animates {
            lineLayer.strokeEnd = 0
        }
    }
}

extension BezierView {
    
    func animateLayers() {
        animatePoints()
        animateLine()
    }
    
    func animatePoints() {
        
        var delay = 0.2
        
        for point in pointLayers {
            
            let fadeAnimation = CABasicAnimation(keyPath: "opacity")
            fadeAnimation.toValue = 1
            fadeAnimation.beginTime = CACurrentMediaTime() + delay
            fadeAnimation.duration = 0.2
            fadeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            fadeAnimation.fillMode = kCAFillModeForwards
            fadeAnimation.isRemovedOnCompletion = false
            point.add(fadeAnimation, forKey: kFadeAnimationKey)
            
            delay += 0.15
        }
    }
    
    func animateLine() {
        
        let growAnimation = CABasicAnimation(keyPath: "strokeEnd")
        growAnimation.toValue = 1
        growAnimation.beginTime = CACurrentMediaTime() + 0.5
        growAnimation.duration = 1.5
        growAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        growAnimation.fillMode = kCAFillModeForwards
        growAnimation.isRemovedOnCompletion = false
        lineLayer.add(growAnimation, forKey: kStrokeAnimationKey)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
