// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// タップでメンバーを招待しよう！
  internal static let memberPlaceHolder = L10n.tr("Localizable", "member_placeHolder")
  /// %@が新しいウォレットを作成しました。共有のウォレットを管理しよう！\n招待コード『%@』で参加できます！
  internal static func memberShare(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "member_share", String(describing: p1), String(describing: p2))
  }
  /// マイページ
  internal static let titleMypage = L10n.tr("Localizable", "title_mypage")
  /// 招待コードを入力
  internal static let titleParticipate = L10n.tr("Localizable", "title_participate")
  /// お支払い
  internal static let titlePayment = L10n.tr("Localizable", "title_payment")
  /// 設定
  internal static let titleSetting = L10n.tr("Localizable", "title_setting")
  /// ウォレット
  internal static let titleWallet = L10n.tr("Localizable", "title_wallet")
  /// 交際費
  internal static let walletTypeNameEntertainment = L10n.tr("Localizable", "walletTypeName_entertainment")
  /// 食費
  internal static let walletTypeNameFood = L10n.tr("Localizable", "walletTypeName_food")
  /// 生活費
  internal static let walletTypeNameLife = L10n.tr("Localizable", "walletTypeName_life")
  /// 雑費
  internal static let walletTypeNameOther = L10n.tr("Localizable", "walletTypeName_other")
  /// 教育費
  internal static let walletTypeNameStudy = L10n.tr("Localizable", "walletTypeName_study")
  /// 交通費
  internal static let walletTypeNameTrain = L10n.tr("Localizable", "walletTypeName_train")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
