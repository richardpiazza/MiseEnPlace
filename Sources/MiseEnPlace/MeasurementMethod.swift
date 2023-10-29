import Foundation

/// The `MeasurementMethod` represents the ways in which something can be measured.
///
/// In the case of the **MiseEnPlace** framework, this means _Volume_ and _Mass_.
public enum MeasurementMethod: Int {
    case quantity = 0
    case volume = 1
    case weight = 2
}
