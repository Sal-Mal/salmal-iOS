import ProjectDescription

let frameworkNameAttribute: Template.Attribute = .required("name")

let frameworkTemplate = Template(
  description: "Custom Framework Template",
  attributes: [frameworkNameAttribute],
  items: [
    .file(
      path: "Project.swift",
      templatePath: "Project.stencil"
    ),
    .file(
      path: "Tests/\(frameworkNameAttribute)Tests.swift",
      templatePath: "FrameworkTests.stencil"
    ),
    .string(
      path: "Sources/Dummy.swift",
      contents: "// Empty Files"
    ),
    .file(
      path: "DemoApp/Sources/\(frameworkNameAttribute)App.swift",
      templatePath: "App.stencil"
    ),
    .file(
      path: "DemoApp/Sources/ContentView.swift",
      templatePath: "ContentView.stencil"
    ),
    .file(
      path: "DemoApp/Resources/LaunchScreen.storyboard",
      templatePath: "LaunchScreen.stencil"
    ),
  ]
)
