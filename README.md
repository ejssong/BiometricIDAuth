# :bulb: Local Authentication ?  

> FaceID , TouchID, OpticID (Vision Pro 출시와 함께 공개된 홍체 인식) 와 같은 생체 인식을 통해서 디바이스에 접근 할 수 있다.
> 보안상 앱이 직접적으로 인증 데이터에 접근할 수는 없고 `Secure Enclave` 통해서 결과 값만 받을 수 있다.

<img width="640" alt="스크린샷 2024-06-03 오후 1 55 27" src="https://github.com/ejssong/BiometricIDAuth/assets/59044882/c45fb360-eff9-49e8-83b3-1f20793e7f95">


## FaceID 권한 요청 방법

<img width = "700" alt="FaceIDInfoPlist" src="https://github.com/ejssong/BiometricIDAuth/assets/59044882/4575acf5-059d-412f-a85c-c8e5af2272ce">

```swift
LAPolicy 
- .deviceOwnerAuthenticationWithBiometrics //FallBack 버튼 (인증 실패 했을 때 나오는 암호 입력 버튼)을 눌러도 빈 화면 나옴 
- .deviceOwnerAuthentication //생체 인식이 등록 되어있는 경우, 생체 인식 인증 실행. 인증이 등록 되어 있지 않거나 실패 할 경우 암호 인증 실행 


LAContext
- localizedFallbackTitle //빈 값일 경우 FallBack 버튼을 숨길 수 있다.
- localizedCancelTitle //바이오 인증 실패 시 나오는 취소 버튼 라벨 
```


## 구현 방법

```swift
//인증 처리 가능 여부 체크
func canEvaluate(completion: @escaping (Bool, BiometricError?) -> Void) {
    guard context.canEvaluatePolicy(policy, error: &error) else {
        let type = biometricType(for: context.biometryType)
        
        guard let error = error else { return completion(false, nil) }
        
        return completion(false, biometricError(from: error))
    }
    completion(true, nil)
}
 
//인증 처리 
func evaluatePolicy(completion: @escaping (Bool, BiometricError?) -> Void) {
     let localizedReason = "Verify your identity" //빈 값이면 에러 떨어짐

     context.evaluatePolicy(policy, localizedReason: localizedReason) { [weak self] success, error in
	//내부적으로 FaceID 성공, 실패 여부에 따라 처리
        DispatchQueue.main.async {
            if success {
		completion(true, nil)
            }else {
                guard let error = error else { return completion(false, nil) }
                completion(false, self?.biometricError(from: error as NSError))
            }
        }
    }
}
```

## Error 처리
```swift
enum BiometricError: LocalizedError {
    case biometryNotAvailable  //생체 인증 지원 X  -> LAError.biometryNotAvailable
    case biometryNotEnrolled   //생체 인증 등록 X  -> LAError.biometryNotEnrolled
    case authenticationFailed  //생체 인증 실패    -> LAError.authenticationFailed
    case userCancel             //셍체 인증 취소   -> LAError.userCancel
    case userFallback           //패스워드 입력    -> LAError.userFallback
    case biometryLockout        //생체 인증 잠김   -> LAError.biometryLockout
    case unknown
}
```

## Toss 생체 인증 설정 로직 

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/ejssong/BiometricIDAuth/assets/59044882/7782248e-cbc6-426c-a9ab-d29ed3cbd0c2">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/ejssong/BiometricIDAuth/assets/59044882/5f063ad4-4e1e-4d69-bc2b-88ef1683c74f">
  <img width = "323" alt="tossBioAuthLogic" src="https://github.com/ejssong/BiometricIDAuth/assets/59044882/5f063ad4-4e1e-4d69-bc2b-88ef1683c74f">
</picture>


## 생체 인증 설정 로직 (안드 & iOS 동일)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/ejssong/BiometricIDAuth/assets/59044882/d91cc7dd-d37e-470d-9d2f-353cb66b541f">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/ejssong/BiometricIDAuth/assets/59044882/16a93c51-ded7-4725-833f-c01655666243">
  <img width = "1000" alt="BioAuthLogic" src="https://github.com/ejssong/BiometricIDAuth/assets/59044882/16a93c51-ded7-4725-833f-c01655666243">
</picture>

