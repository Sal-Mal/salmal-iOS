//
//  PermissionService.swift
//  Core
//
//  Created by 청새우 on 2024/02/04.
//

import Foundation
import AVFoundation
import Photos

public enum PermissionService {
  /// 카메라 권한을 요청합니다.
  /// - Returns: 카메라 권한 허용 여부
  public static func requestCameraPermission() async -> Bool {
    return await AVCaptureDevice.requestAccess(for: .video)
  }
  
  public static func requestPhotoPermission() async -> Bool {
    let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    
    switch status {
    case .notDetermined:
      return false
    case .restricted:
      return false
    case .denied:
      return false
    case .authorized:
      return true
    case .limited:
      return false
    @unknown default:
      return false
    }
  }
}
