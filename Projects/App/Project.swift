// Project.stencil

import ProjectDescription

let nativeAppKey = "5d5170916ea2715b891b88b5dc7cba0f"

let project = Project(
  name: "SalmalApp",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  targets: [
    Target(
      name: "SalmalApp",
      platform: .iOS,
      product: .app,
      bundleId: "com.salmal.SalmalApp",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen",
        "LSApplicationQueriesSchemes": ["kakaokompassauth"],
        "CFBundleURLTypes": [
          [
            "CFBundleURLSchemes": ["kakao\(nativeAppKey)"],
            "CFBundleURLName": "com.salmal.app"
          ]
        ],
        
        "NSPhotoLibraryUsageDescription": "살말 업로드를 위해 앨범 접근권한이 필요해요",
        "NSCameraUsageDescription": "살말 업로드를 위해 카메라 접근권한이 필요해요"
      ]),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "MainFeature", path: "../MainFeature"),
        .project(target: "LoginFeature", path: "../LoginFeature"),
        .project(target: "ProfileFeature", path: "../ProfileFeature"),
        .project(target: "UploadFeature", path: "../UploadFeature")
      ]
    )
  ]
)
