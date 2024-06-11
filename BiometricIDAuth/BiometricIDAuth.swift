//
//  BiometricIDAuth.swift
//  BiometricIDAuth
//
//  Created by ejsong on 6/3/24.
//

import Foundation
import LocalAuthentication

class BiometricIDAuth {
    
    private let context = LAContext()
    
    private let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    
    private var error: NSError?
    
    init() {
        context.localizedFallbackTitle = ""
        context.localizedCancelTitle = "취소"
    }
    
    func checkBiometricIDAuth(completion: @escaping (Bool, BiometricError?) -> Void) {
        canEvaluate { [weak self] (canEvaluate, canEvaluateError) in
            guard canEvaluate else { return completion(false, canEvaluateError) }
        
            self?.evaluate { (success, error) in
                guard success else { return completion(false, error) }
                completion(true, nil)
                print("BIOMETRIC SUCCESS!")
            }
        }
    }
    
    /**
     바이오 인증 지원 가능 여부 체크
     */
    func canEvaluate(completion: @escaping (Bool, BiometricError?) -> Void) {
        guard context.canEvaluatePolicy(policy, error: &error) else {
            let type = biometricType(for: context.biometryType)
            
            guard let error = error else { return completion(false, nil)
            }
            
            return completion(false, biometricError(from: error))
        }
    
        completion(true, nil)
    }
    
    func evaluate(completion: @escaping (Bool, BiometricError?) -> Void) {
        let localizedReason = "생체 인증을 진행해주세요"
        context.evaluatePolicy(policy, localizedReason: localizedReason) { [weak self] success, error in
    
            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    guard let error = error else { return completion(false, nil) }
                    
                    completion(false, self?.biometricError(from: error as NSError))
                }
            }
        }
    }
    
    private func biometricType(for type: LABiometryType) -> BiometricType {
        switch type {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        default:
            return .unknown
        }
    }
    
    private func biometricError(from nsError: NSError) -> BiometricError {
        let error: BiometricError
        
        switch nsError {
        case LAError.authenticationFailed:
            error = .authenticationFailed
        case LAError.userCancel:
            error = .userCancel
        case LAError.userFallback:
            error = .userFallback
        case LAError.biometryNotAvailable:
            error = .biometryNotAvailable
        case LAError.biometryNotEnrolled:
            error = .biometryNotEnrolled
        case LAError.biometryLockout:
            error = .biometryLockout
        default:
            error = .unknown
        }
        
        return error
    }
    
    deinit {
        print("BIOMETRIC ID AUTH DEINIT")
    }
}


