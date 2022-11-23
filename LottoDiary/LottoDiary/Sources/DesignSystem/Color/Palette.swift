//
//  Palette.swift
//  LottoDiary
//
//  Created by uiskim on 2022/11/23.
//

import UIKit

enum Palette: String {
    case mainOrange
    case mainBlue
//    case mainGreen
//    case mainYellow
//    case backgroundBlack
//    case gray2B2C35
//    case gray2D2B35
//    case black
//    case white
    
    var hexString: String {
        switch self {
        case .mainOrange:
            return "#EC6E59FF"
        case .mainBlue:
            return "#4880EEFF"
//        case .mainGreen:
//            return "#05b12b"
//        case .mainYellow:
//            <#code#>
//        case .backgroundBlack:
//            <#code#>
//        case .gray2B2C35:
//            <#code#>
//        case .gray2D2B35:
//            <#code#>
//        case .black:
//            <#code#>
//        case .white:
//            <#code#>
        }
    }
}
