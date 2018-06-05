//
//  ViewController.swift
//  bezierNew
//
//  
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstBezierView: BezierView!
    
    let dataPoints = [10, 550, 220, 101, 2, 101, 220, 252, 11, -10, 18, 33, 40, -100, 100]
    
    var xAxisPoints : [Double] {
        var points = [Double]()
        for i in 0..<dataPoints.count {
            let val = Double(i)*50
            points.append(val)
        }
        
        return points
    }
    
    var yAxisPoints: [Double] {
        var points = [Double]()
        for i in dataPoints {

            let val = Double(i)/5 + self.firstBezierView.frame.height.f/2
            points.append(val)
        }
        
        return points
    }
    
    var graphPoints : [CGPoint] {
        var points = [CGPoint]()
        for i in 0..<dataPoints.count {
            let val = CGPoint(x: self.xAxisPoints[i], y: self.yAxisPoints[i])
            points.append(val)
        }
        
        return points
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstBezierView.dataSource = self as BezierViewDataSource
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.firstBezierView.layoutSubviews()
    }

}

extension ViewController: BezierViewDataSource {
    
    func bezierViewDataPoints(bezierView: BezierView) -> [CGPoint] {
        
        return graphPoints
    }
}

