//
//  Biometric+Model.swift
//  BiometricIDAuth
//
//  Created by ejsong on 6/11/24.
//

import Foundation
import UIKit

enum BiometricType {
    case none
    case touchID
    case faceID
    case unknown
}

enum BiometricError: LocalizedError {
    case biometryNotAvailable  //생체 인증 지원 X
    case biometryNotEnrolled   //생체 인증 등록 X
    case authenticationFailed  //생체 인증 실패
    case userCancel             //셍체 인증 취소
    case userFallback           //패스워드 입력
    case biometryLockout       //생체 인증 잠김
    case unknown
    
    
    var errorType : Int {
        switch self {
        case .biometryNotAvailable: return 0
        case .biometryNotEnrolled: return 1
        default: return 2
        }
    }
    
    var errorPopupTitle: String? {
        switch errorType {
        case 1: return "생체 인증을 등록하시겠습니까?"
        default: return nil
        }
    }
    
    var confirmAction: Void? {
        switch errorType {
        case 1:
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        default: nil
        }
    }
}
