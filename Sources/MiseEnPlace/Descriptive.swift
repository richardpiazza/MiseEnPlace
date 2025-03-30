/// Parameters that describe and categorize an object.
///
/// Although all of the properties are `Optional<String>`, best practices are to provide values for each;
/// with `name` provided at a minimum.
///
/// ## Required Conformance
///
/// ```swift
/// /// The common, short, human-understandable text.
/// var name: String { get set }
///
/// /// The expanded description i.e. 'notes'
/// var commentary: String { get set }
///
/// /// The scientific or structured identity of the item.
/// var classification: String { get set }
/// ```
///
/// ## Example
///
/// ```swift
/// struct FoodStuff: Descriptive {
///     var name: String = "Whole Milk"
///     var commentary: String = "The mammary lactations from a bovine."
///     var classification: String = "Dairy, Milk, Cow, Whole/Full Fat"
/// }
/// ```
public protocol Descriptive {
    /// The common, short, human-understandable text.
    var name: String { get set }
    /// The expanded description i.e. 'notes'
    var commentary: String { get set }
    /// The scientific or structured identity of the item.
    var classification: String { get set }
}

public extension Descriptive {
    /// Returns the first character from `name` or "" (empty string).
    @available(*, deprecated)
    var indexCharacter: String {
        guard name.count > 0 else {
            return ""
        }

        let range = name.startIndex ..< name.index(name.startIndex, offsetBy: 1)
        return name[range].uppercased()
    }
}
