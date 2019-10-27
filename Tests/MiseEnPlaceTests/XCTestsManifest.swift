import XCTest

#if !os(macOS) && !os(iOS) && !os(tvOS) && !os(watchOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ConfigurationTests.allTests),
        testCase(EachMeasurementUnitTests.allTests),
        testCase(SignificantDigitTests.allTests),
    ]
}
#endif
