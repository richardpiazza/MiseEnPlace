import Foundation

/// Used to ordering elements when represented in un-ordered collections
///
/// ## Requied Conformance
///
/// ```swift
/// // The order of the element
/// var sequence: Int { get set }
/// ```
///
public protocol Sequenced {
    // The order of the element
    var sequence: Int { get set }
}
