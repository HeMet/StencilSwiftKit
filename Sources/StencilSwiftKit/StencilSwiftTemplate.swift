//
// StencilSwiftKit
// Copyright © 2021 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

#if os(Linux) && !swift(>=3.1)
typealias NSRegularExpression = RegularExpression
#endif

// Workaround until Stencil fixes https://github.com/stencilproject/Stencil/issues/22
open class StencilSwiftTemplate: Template {
  #if os(Windows)
  // line terminator
  private let lt: Character = "\r\n"
  // escaped line terminator
  private let elt = "\\r\\n"
  #else
  private let lt: Character = "\n"
  private let elt = "\\n"
  #endif

  public required init(templateString: String, environment: Environment? = nil, name: String? = nil) {
    let templateStringWithMarkedNewlines = templateString
      .replacingOccurrences(of: "\(lt)\(lt)", with: "\(lt)\u{000b}\(lt)")
      .replacingOccurrences(of: "\(lt)\(lt)", with: "\(lt)\u{000b}\(lt)")
    super.init(templateString: templateStringWithMarkedNewlines, environment: environment, name: name)
  }

  // swiftlint:disable:next discouraged_optional_collection
  override open func render(_ dictionary: [String: Any]? = nil) throws -> String {
    try removeExtraLines(from: super.render(dictionary))
  }

  // Workaround until Stencil fixes https://github.com/stencilproject/Stencil/issues/22
  private func removeExtraLines(from str: String) -> String {
    let extraLinesRE: NSRegularExpression = {
      do {
        return try NSRegularExpression(pattern: "\(elt)([ \\t]*\(elt))+", options: [])
      } catch {
        fatalError("Regular Expression pattern error: \(error)")
      }
    }()
    let compact = extraLinesRE.stringByReplacingMatches(
      in: str,
      options: [],
      range: NSRange(location: 0, length: str.utf16.count),
      withTemplate: "\(lt)"
    )
    let unmarkedNewlines = compact
      .replacingOccurrences(of: "\(lt)\u{000b}\(lt)", with: "\(lt)\(lt)")
      .replacingOccurrences(of: "\(lt)\u{000b}\(lt)", with: "\(lt)\(lt)")
    return unmarkedNewlines
  }
}
