import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(InstructionTests.allTests),
        testCase(InstructionTranslationTests.allTests),
        testCase(PathTests.allTests),
        testCase(PolygonTests.allTests),
        testCase(VectorPlusTests.allTests),
    ]
}
#endif
