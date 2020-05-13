import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PathTests.allTests),
        testCase(VectorPlusTests.allTests),
    ]
}
#endif
