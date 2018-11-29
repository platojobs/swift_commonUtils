import AVFoundation

protocol CameraShowableProtocol {
    func confirmCameraAuthorizationStatus(result: @escaping (CameraStatus, _ isFirstTime: Bool) -> Void)
}

enum CameraStatus : Int {
    case notDetermined, restricted, denied, authorized
}

extension CameraShowableProtocol {
    func confirmCameraAuthorizationStatus(result: @escaping (CameraStatus, _ isFirstTime: Bool) -> Void)  {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        if status == .notDetermined {
            requestAuthorization { (isAuthorized) in
                DispatchQueue.main.async {
                    result(isAuthorized ? .authorized : .denied, true)
                }
            }
        } else {
            DispatchQueue.main.async {
                result(CameraStatus(rawValue: status.rawValue) ?? .denied, false)
            }
        }
    }

    private func requestAuthorization(result: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { (isAuthorized) in
            result(isAuthorized)
        }
    }
}
