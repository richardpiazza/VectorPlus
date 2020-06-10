import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(InstructionTranslationTests.allTests),
        testCase(VectorPlusTests.allTests),
    ]
}
#endif
