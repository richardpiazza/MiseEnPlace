import Foundation

/// A preparation step for a `Recipe`
///
/// ## Required Conformance
///
/// ```swift
/// // The `Recipe` that uses this as part of it's `procedureElements`.
/// var inverseRecipe: Recipe? { get set }
/// ```
///
/// ## Protocol Conformance
///
/// _Unique_
/// ```swift
/// var uuid: String { get set }
/// var creationDate: Date { get set }
/// var modificationDate: Date { get set }
/// ```
///
/// _Descriptive_
/// ```swift
/// var name: String { get set }
/// var commentary: String { get set }
/// var classification: String { get set }
/// ```
///
/// _Sequenced_
/// ```swift
/// var sequence: Int { get set }
/// ```
///
/// _Multimedia_
/// ```swift
/// var imageData: Data? { get set }
/// var imagePath: String? { get set }
/// ```
///
public protocol ProcedureElement: Unique, Descriptive, Sequenced, Multimedia {
    var inverseRecipe: Recipe? { get set }
}
