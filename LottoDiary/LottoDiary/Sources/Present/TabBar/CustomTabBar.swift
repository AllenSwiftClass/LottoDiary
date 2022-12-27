//
//  CustomTabBar.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/12/01.
//

import UIKit
import SnapKit

class CustomTabBar: UITabBar {
    
    // MARK: - Properties
    public var middleBtnActionHandler: () -> () = {}
    
    private var shapeLayer: CALayer?
    
    let middleButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .designSystem(.mainBlue)
        
        var titleAttr = AttributedString.init("로또 QR")
        titleAttr.font = .gmarksans(weight: .bold, size: ._13)
        config.attributedSubtitle = titleAttr
        config.titleAlignment = .center
        
        let image = UIImage(systemName: "qrcode")
        // image 사이즈 조정
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        config.preferredSymbolConfigurationForImage = imageConfig
        config.image = image
        config.imagePadding = 5
        config.imagePlacement = .top
        
        return UIButton(configuration: config)
    }()
    
    let middleButtonSize: Double = 80
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        addShape()
    }
    
    // MARK: - Helpers
    
    private func setupTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .designSystem(.gray2B2C35)
        // tabBarItem font 변경
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font : UIFont.gmarksans(weight: .regular, size: ._11)]
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.font : UIFont.gmarksans(weight: .medium, size: ._11)]
        
        self.standardAppearance = tabBarAppearance
        self.scrollEdgeAppearance = tabBarAppearance
        self.itemSpacing = 130
        self.tintColor = .white
        
        
        
        self.frame.size.height += 50
    }
    
    private func setupMiddleBtn() {
        self.addSubview(middleButton)
        
        middleButton.frame = CGRect(x: ( self.bounds.width / 2)-(middleButtonSize / 2), y: -(middleButtonSize / 2), width: middleButtonSize, height: middleButtonSize)
        middleButton.clipsToBounds = true
        middleButton.layer.cornerRadius = middleButton.frame.width / 2
        middleButton.addTarget(self, action: #selector(middleBtnAction), for: .touchUpInside)
    }
    
    @objc func middleBtnAction() {
        middleBtnActionHandler()
//        print("tapped")
    }
    
    // middleButton 전역 touch 활성화
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        return self.middleButton.frame.contains(point) ? self.middleButton : super.hitTest(point, with: event)
    }
    
    // 곡선 TabBar
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.designSystem(.gray2B2C35)?.cgColor
        shapeLayer.lineWidth = 0
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
        self.setupMiddleBtn()
    }
    
    private func createPath() -> CGPath {
        // (middleButton+추가여백) 을 만들 원의 반지름
        let extraRadius = CGFloat(middleButtonSize / 2.0) + 5
        let height = frame.height
        let width = frame.width
        let halfWidth = frame.width/2.0
        let path = UIBezierPath()
        path.move(to: .zero)
        
        // middleButton + 추가 여백 만큼 원 그리기
        path.addArc(withCenter: CGPoint(x: halfWidth , y: 0), radius: extraRadius , startAngle: .pi, endAngle: 0, clockwise: false)
        
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0.0, y: height))
        
        return path.cgPath
    }
}
