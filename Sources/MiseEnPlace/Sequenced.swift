import Foundation

/// Used to ordering elements when represented in un-ordered collections
///
/// ## Required Conformance
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
