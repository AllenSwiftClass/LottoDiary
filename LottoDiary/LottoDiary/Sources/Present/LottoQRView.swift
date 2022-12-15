//
//  LottoQRViewController.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/12/02.
//

import UIKit
import QRCodeReader
import AVFoundation

final class LottoQRView: UIView, QRCodeReaderDisplayable {
    var cameraView: UIView = UIView()
    
    var cancelButton: UIButton?
    
    var switchCameraButton: UIButton?
    
    var toggleTorchButton: UIButton?
    
    var overlayView: QRCodeReaderViewOverlay?
    
    func setNeedsUpdateOrientation() {
        
    }
    
    func setupComponents(with builder: QRCodeReaderViewControllerBuilder) {
        
        // 플래시 버튼
        builder.showTorchButton = false
        builder.showSwitchCameraButton = true
        builder.showCancelButton = false
        builder.showOverlayView = true
        // 가이드라인 선
        builder.rectOfInterest = CGRect(x: 0.2, y: 0.3, width: 0.6, height: 0.3)
    }
}
