//
//  PermissionService.swift
//  Core
//
//  Created by 청새우 on 2024/02/04.
//

import Foundation
import AVFoundation

public enum PermissionService {
  /// 카메라 권한을 요청합니다.
  /// - Returns: 카메라 권한 허용 여부
  public static func requestCameraPermission() async -> Bool {
    return await AVCaptureDevice.requestAccess(for: .video)
  }
}
