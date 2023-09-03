//
//  SMIcon.swift
//  UI
//
//  Created by 청새우 on 2023/09/03.
//

import SwiftUI

extension SM {

  public enum Icon {

    public static var home: Image {
      return .init("home", bundle: SM.bundle)
    }

    public static var arrowLeft: Image {
      return .init("arrow.left", bundle: SM.bundle)
    }

    public static var bookmarkFill: Image {
      return .init("bookmark.fill", bundle: SM.bundle)
    }

    public static var bookmark: Image {
      return .init("bookmark", bundle: SM.bundle)
    }

    public static var camera: Image {
      return .init("camera", bundle: SM.bundle)
    }

    public static var cancel: Image {
      return .init("cancel", bundle: SM.bundle)
    }

    public static var check: Image {
      return .init("check", bundle: SM.bundle)
    }

    public static var delete: Image {
      return .init("delete", bundle: SM.bundle)
    }

    public static var edit: Image {
      return .init("edit", bundle: SM.bundle)
    }

    public static var heartFill: Image {
      return .init("heart.fill", bundle: SM.bundle)
    }

    public static var heart: Image {
      return .init("heart", bundle: SM.bundle)
    }

    public static var homeFill: Image {
      return .init("home.fill", bundle: SM.bundle)
    }

    public static var list: Image {
      return .init("list", bundle: SM.bundle)
    }

    public static var message: Image {
      return .init("message", bundle: SM.bundle)
    }

    public static var personFill: Image {
      return .init("person.fill", bundle: SM.bundle)
    }

    public static var person: Image {
      return .init("person", bundle: SM.bundle)
    }

    public static var plusCircle: Image {
      return .init("plus.circle", bundle: SM.bundle)
    }

    public static var plus: Image {
      return .init("plus", bundle: SM.bundle)
    }

    public static var send: Image {
      return .init("send", bundle: SM.bundle)
    }

    public static var setting: Image {
      return .init("setting", bundle: SM.bundle)
    }

    public static var warning: Image {
      return .init("warning", bundle: SM.bundle)
    }

    public static var xmarkCircle: Image {
      return .init("xmark.circle", bundle: SM.bundle)
    }

    public static var xmark: Image {
      return .init("xmark", bundle: SM.bundle)
    }
  }
}

/*
// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum UIAsset {
  public static let black = UIColors(name: "Black")
  public static let gray1 = UIColors(name: "Gray1")
  public static let gray2 = UIColors(name: "Gray2")
  public static let gray3 = UIColors(name: "Gray3")
  public static let gray4 = UIColors(name: "Gray4")
  public static let green1 = UIColors(name: "Green1")
  public static let green2 = UIColors(name: "Green2")
  public static let white = UIColors(name: "White")
  public static let white20 = UIColors(name: "White20")
  public static let white36 = UIColors(name: "White36")
  public static let white80 = UIColors(name: "White80")
  public static let home = UIImages(name: "Home")
  public static let arrowLeft = UIImages(name: "arrow.left")
  public static let bookmarkFill = UIImages(name: "bookmark.fill")
  public static let bookmark = UIImages(name: "bookmark")
  public static let camera = UIImages(name: "camera")
  public static let cancel = UIImages(name: "cancel")
  public static let check = UIImages(name: "check")
  public static let delete = UIImages(name: "delete")
  public static let edit = UIImages(name: "edit")
  public static let heartFill = UIImages(name: "heart.fill")
  public static let heart = UIImages(name: "heart")
  public static let homeFill = UIImages(name: "home.fill")
  public static let list = UIImages(name: "list")
  public static let message = UIImages(name: "message")
  public static let personFill = UIImages(name: "person.fill")
  public static let person = UIImages(name: "person")
  public static let plusCircle = UIImages(name: "plus.circle")
  public static let plus = UIImages(name: "plus")
  public static let send = UIImages(name: "send")
  public static let setting = UIImages(name: "setting")
  public static let warning = UIImages(name: "warning")
  public static let xmarkCircle = UIImages(name: "xmark.circle")
  public static let xmark = UIImages(name: "xmark")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class UIColors {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if canImport(SwiftUI)
  private var _swiftUIColor: Any? = nil
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) var swiftUIColor: SwiftUI.Color {
    get {
      if self._swiftUIColor == nil {
        self._swiftUIColor = SwiftUI.Color(asset: self)
      }

      return self._swiftUIColor as! SwiftUI.Color
    }
    set {
      self._swiftUIColor = newValue
    }
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension UIColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: UIColors) {
    let bundle = UIResources.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  init(asset: UIColors) {
    let bundle = UIResources.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct UIImages {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = UIResources.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension UIImages.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the UIImages.image property")
  convenience init?(asset: UIImages) {
    #if os(iOS) || os(tvOS)
    let bundle = UIResources.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: UIImages) {
    let bundle = UIResources.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: UIImages, label: Text) {
    let bundle = UIResources.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: UIImages) {
    let bundle = UIResources.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:enable all
// swiftformat:enable all
*/
