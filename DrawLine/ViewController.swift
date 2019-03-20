//
//  ViewController.swift
//  DrawLine
//
//  Created by xuewu.yang on 2019/3/14.
//  Copyright © 2019 wilson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let view1 = NavigationView()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let viewRect = CGRect(x: 100, y: 100, width: 60 , height: 60)
        view1.frame = viewRect
        view1.layer.anchorPoint = CGPoint(x: 0, y: 0)
        self.view.addSubview(view1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func angle(_ sender: UISlider) {
        //独立旋转，以初始位置旋转
        self.view1.transform = CGAffineTransform(rotationAngle: CGFloat(sender.value*Float.pi/180))
    }
    
    @IBAction func size(_ sender: UISlider) {
        view1.updateSize(size: sender.value)
    }
}

class NavigationView:UIView{
    
    var gradLayer = CAGradientLayer()
    var size:Float = 0.3*Float.pi
    var length:Float = 80
    var colorArray = [  _ColorLiteralType(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1).cgColor, _ColorLiteralType(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0).cgColor]
    override init(frame: CGRect) {
        super.init(frame: frame)
        //把背景色设为透明
        self.backgroundColor = UIColor.clear
        gradLayer.frame = CGRect(x: 2.5, y:2.5, width: 60, height: 60)
        gradLayer.colors = colorArray
        gradLayer.startPoint = CGPoint(x: 0, y: 0)
        gradLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func  updateSize(size:Float){
        self.size = size*Float.pi
        setNeedsDisplay()
    }
   
    override func draw(_ rect: CGRect) {
      
        let startAngle =  CGFloat((1/2)*Float.pi-size)
        let endAngle  =  CGFloat(size)
      
        if startAngle < endAngle{
           // 扇形
            let  apath =  UIBezierPath(arcCenter: CGPoint(x: 0,y:0), radius: 60, startAngle:startAngle, endAngle:endAngle, clockwise: true)
            apath.addLine(to: CGPoint(x: 0, y: 0))
            apath.lineWidth = 1.0
            apath.close()
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = apath.cgPath
            gradLayer.mask = shapeLayer
        }
   
        let circleColor = UIColor.yellow
        circleColor.set() // 设置线条颜色
        let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 5, height: 5)) // 如果传入的是长方形，画出的就是内切椭圆
        circlePath.lineWidth = 5.0 // 线条宽度
        circlePath.stroke()
        circlePath.close()
        circlePath.fill()

        let lineColor = UIColor.yellow
        lineColor.set() // 设置线条颜色
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x:2.5 , y:2.5))
        linePath.addLine(to: CGPoint(x: 70,y:70))
        linePath.lineWidth = 1.0
        linePath.setLineDash([5,5,5,5,5,5], count: 6, phase: 0.0)
        linePath.stroke()
        linePath.close()
    }
}


//渐变View
class  MyGradientView :UIView{
      var colorArray = [  _ColorLiteralType(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1).cgColor, _ColorLiteralType(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0).cgColor]
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        
        let gradLayer = CAGradientLayer()
        gradLayer.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        gradLayer.colors = colorArray
        gradLayer.startPoint = CGPoint(x: 0, y: 0)
        gradLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradLayer)
        
        let  apath =  UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 60, startAngle:0, endAngle: 60*CGFloat.pi/180, clockwise: true)
        apath.addLine(to: CGPoint(x: 0, y: 0))
        apath.lineWidth = 1.0
        apath.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = apath.cgPath
        gradLayer.mask = shapeLayer
    }
}


class MyCanvas: UIView {
    
    var startPoint = CGPoint(x: 0, y: 0)
    var endPoint = CGPoint(x: 0, y: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //把背景色设为透明
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint =  (touches.first?.location(in: self))!
        
    }
 

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        endPoint = (touches.first?.location(in: self))!
        
        print(" \(endPoint)")
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(CGLineCap.round)//
        context?.setLineWidth(2)// 线宽
        context?.setAllowsAntialiasing(true)// 锯齿
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.beginPath()
        context?.move(to: CGPoint(x: startPoint.x , y: startPoint.y))
        context?.addLine(to: CGPoint(x: startPoint.x , y: endPoint.y))
        context?.addLine(to: CGPoint(x: endPoint.x , y: endPoint.y))
        context?.addLine(to: CGPoint(x: endPoint.x , y: startPoint.y))
        context?.addLine(to: CGPoint(x: startPoint.x , y: startPoint.y))
        context?.strokePath()
        UIGraphicsEndImageContext()
        print("wilson    neet")
    }
}
