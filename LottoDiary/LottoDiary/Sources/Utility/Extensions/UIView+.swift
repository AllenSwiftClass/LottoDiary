//
//  UIView+.swift
//  LottoDiary
//
//  Created by uiskim on 2022/12/18.
//
import UIKit

extension UIView {
     /// 화면에 여러 View들을 추가합니다
     /// - Parameter views: 추가할 View들
     func addSubviews(_ views: UIView...) {
         views.forEach { view in
             addSubview(view)
         }
     }
 }
