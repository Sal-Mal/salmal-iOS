// Project.stencil

import ProjectDescription

let project = Project(
    name: "SalmalApp",
    targets: [
        Target(
            name: "SalmalApp",
            platform: .iOS,
            product: .app,
            bundleId: "com.salmal.SalmalApp",
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "UILaunchStoryboardName": "LaunchScreen"
            ]),
     	    sources: ["Sources/**"],
	    resources: ["Resources/**"],
            dependencies: [   
                
            ]
        )
    ]
)
