import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CircleTests.allTests),
        testCase(InstructionTests.allTests),
        testCase(InstructionTranslationTests.allTests),
        testCase(PathTests.allTests),
        testCase(PolygonTests.allTests),
        testCase(RectangleTests.allTests),
        testCase(VectorPlusTests.allTests),
    ]
}
#endif
