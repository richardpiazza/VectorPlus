import XCTest
@testable import SVG
@testable import Graphics

final class TransformationTests: XCTestCase {
    
    static var allTests = [
        ("testTranslateInitialization", testTranslateInitialization),
        ("testMatrixInitialization", testMatrixInitialization),
    ]
    
    func testTranslateInitialization() {
        var input: String = "translate(0.000000, 39.000000)"
        var transformation: Transformation? = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .translate(x, y) = transformation {
            XCTAssertEqual(x, 0.0, accuracy: 0.00001)
            XCTAssertEqual(y, 39.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
        
        input = "translate(0.0 39.0)"
        transformation = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .translate(x, y) = transformation {
            XCTAssertEqual(x, 0.0, accuracy: 0.00001)
            XCTAssertEqual(y, 39.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
        
        input = "TRANSLATE(0.0,39.0)"
        transformation = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .translate(x, y) = transformation {
            XCTAssertEqual(x, 0.0, accuracy: 0.00001)
            XCTAssertEqual(y, 39.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
    }
    
    func testMatrixInitialization() {
        var input: String = "matrix(1 0 0 1 1449.84 322)"
        var transformation: Transformation? = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .matrix(a, b, c, d, e, f) = transformation {
            XCTAssertEqual(a, 1.0, accuracy: 0.00001)
            XCTAssertEqual(b, 0.0, accuracy: 0.00001)
            XCTAssertEqual(c, 0.0, accuracy: 0.00001)
            XCTAssertEqual(d, 1.0, accuracy: 0.00001)
            XCTAssertEqual(e, 1449.84, accuracy: 0.00001)
            XCTAssertEqual(f, 322.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
        
        input = "matrix(1, 0, 0, 1, 1449.84, 322)"
        transformation = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .matrix(a, b, c, d, e, f) = transformation {
            XCTAssertEqual(a, 1.0, accuracy: 0.00001)
            XCTAssertEqual(b, 0.0, accuracy: 0.00001)
            XCTAssertEqual(c, 0.0, accuracy: 0.00001)
            XCTAssertEqual(d, 1.0, accuracy: 0.00001)
            XCTAssertEqual(e, 1449.84, accuracy: 0.00001)
            XCTAssertEqual(f, 322.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
        
        input = "MATRIX(1,0,0,1,1449.84,322)"
        transformation = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .matrix(a, b, c, d, e, f) = transformation {
            XCTAssertEqual(a, 1.0, accuracy: 0.00001)
            XCTAssertEqual(b, 0.0, accuracy: 0.00001)
            XCTAssertEqual(c, 0.0, accuracy: 0.00001)
            XCTAssertEqual(d, 1.0, accuracy: 0.00001)
            XCTAssertEqual(e, 1449.84, accuracy: 0.00001)
            XCTAssertEqual(f, 322.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
    }
}
