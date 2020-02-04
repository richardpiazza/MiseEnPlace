import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AsNeededTests.allTests),
        testCase(ConfigurationTests.allTests),
        testCase(DescriptiveTests.allTests),
        testCase(DoubleTests.allTests),
        testCase(EachMeasurementUnitTests.allTests),
        testCase(EqualRatioIngredientTests.allTests),
        testCase(FractionTests.allTests),
        testCase(HighMassRatioIngredientTests.allTests),
        testCase(HighVolumeRatioIngredientTests.allTests),
        testCase(InterpreterTests.allTests),
        testCase(LooseConversionTests.allTests),
        testCase(MeasurementUnitTests.allTests),
        testCase(RatioTests.allTests),
        testCase(SignificantDigitTests.allTests),
    ]
}
#endif
