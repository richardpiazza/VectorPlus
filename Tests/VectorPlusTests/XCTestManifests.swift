import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PathTests.allTests),
        testCase(PolygonTests.allTests),
        testCase(VectorPlusTests.allTests),
    ]
}
#endif
