//
//  AnyObject+Then.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import Foundation
import CoreGraphics
import Foundation
#if os(iOS) || os(tvOS)
import UIKit.UIGeometry
#endif

public protocol Then {}

extension Then where Self: Any {
  /// Makes it available to set properties with closures just after initializing and copying the value types.
  ///
  ///     let frame = CGRect().with {
  ///       $0.origin.x = 10
  ///       $0.size.width = 100
  ///     }
  public func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
    var copy = self
    try block(&copy)
    return copy
  }
  
  /// Makes it available to execute something with closures.
  ///
  ///     UserDefaults.standard.do {
  ///       $0.set("devxoul", forKey: "username")
  ///       $0.set("devxoul@gmail.com", forKey: "email")
  ///       $0.synchronize()
  ///     }
  public func `do`(_ block: (Self) throws -> Void) rethrows {
    try block(self)
  }
}

extension Then where Self: AnyObject {
  /// Makes it available to set properties with closures just after initializing.
  ///
  ///     let label = UILabel().then {
  ///       $0.textAlignment = .center
  ///       $0.textColor = UIColor.black
  ///       $0.text = "Hello, World!"
  ///     }
  public func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }
}

extension NSObject: Then { }

extension CGPoint: Then { }
extension CGRect: Then { }
extension CGSize: Then { }
extension CGVector: Then { }
extension Array: Then { }
extension Dictionary: Then {}
extension Set: Then { }

#if os(iOS) || os(tvOS)
extension UIEdgeInsets: Then { }
extension UIOffset: Then { }
extension UIRectEdge: Then { }
#endif
