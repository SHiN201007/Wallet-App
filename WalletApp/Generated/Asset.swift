// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public enum Colors {
    public static let backgroundColor = ColorAsset(name: "backgroundColor")
    public static let blackColor = ColorAsset(name: "blackColor")
    public static let blueBottomColor = ColorAsset(name: "blueBottomColor")
    public static let blueTopColor = ColorAsset(name: "blueTopColor")
    public static let greenBottomColor = ColorAsset(name: "greenBottomColor")
    public static let greenTopColor = ColorAsset(name: "greenTopColor")
    public static let navyColor = ColorAsset(name: "navyColor")
    public static let placeHolderColor = ColorAsset(name: "placeHolderColor")
    public static let purpleBottomColor = ColorAsset(name: "purpleBottomColor")
    public static let purpleTopColor = ColorAsset(name: "purpleTopColor")
    public static let redBottomColor = ColorAsset(name: "redBottomColor")
    public static let redTopColor = ColorAsset(name: "redTopColor")
  }
  public enum Images {
    public static let couple = ImageAsset(name: "couple")
    public static let entertainment = ImageAsset(name: "entertainment")
    public static let father = ImageAsset(name: "father")
    public static let food = ImageAsset(name: "food")
    public static let friend = ImageAsset(name: "friend")
    public static let girl = ImageAsset(name: "girl")
    public static let grandmother = ImageAsset(name: "grandmother")
    public static let grandpa = ImageAsset(name: "grandpa")
    public static let invite = ImageAsset(name: "invite")
    public static let life = ImageAsset(name: "life")
    public static let mother = ImageAsset(name: "mother")
    public static let mypage = ImageAsset(name: "mypage")
    public static let other = ImageAsset(name: "other")
    public static let payment = ImageAsset(name: "payment")
    public static let study = ImageAsset(name: "study")
    public static let train = ImageAsset(name: "train")
    public static let wallet = ImageAsset(name: "wallet")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
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

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

public extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
