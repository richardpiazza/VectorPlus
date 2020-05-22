import Foundation
import SVG
import Swift2D

public extension Path {
    init(instructions: [Instruction]) {
        self.init()
        let instructionData = instructions.compactMap({ $0.pathData })
        data = instructionData.joined(separator: " ")
    }
}

// MARK: - InstructionRepresentable
extension Path: InstructionRepresentable {
    public func instructions() throws -> [Instruction] {
        var output: [Instruction] = []
        var instruction: Instruction?
        
        var positioning: Instruction.Positioning = .absolute
        var pathOrigin: Point = .nan
        var currentPoint: Point = .zero
        var argumentPosition: Int = 0
        var singleValue: Bool = false
        
        let components = dataComponents()
        for element in components {
            if let prefix = Instruction.Prefix(rawValue: element.first!) {
                // Setup instruction
                
                switch prefix {
                case .move:
                    instruction = .move(x: .nan, y: .nan)
                    positioning = .absolute
                    
                case .relativeMove:
                    instruction = .move(x: currentPoint.x, y: currentPoint.y)
                    positioning = .relative
                    argumentPosition = 0
                    
                case .line:
                    instruction = .line(x: .nan, y: .nan)
                    positioning = .absolute
                    
                case .relativeLine:
                    instruction = .line(x: currentPoint.x, y: currentPoint.y)
                    positioning = .relative
                    argumentPosition = 0
                    
                case .horizontalLine:
                    guard let lastInstruction = output.last else {
                        throw Instruction.Error.invalidInstructionIndex
                    }
                    
                    instruction = .line(x: .nan, y: lastInstruction.y)
                    positioning = .absolute
                    
                case .relativeHorizontalLine:
                    instruction = .line(x: currentPoint.x, y: currentPoint.y)
                    positioning = .relative
                    argumentPosition = 0
                    singleValue = true
                    
                case .verticalLine:
                    guard let lastInstruction = output.last else {
                        throw Instruction.Error.invalidInstructionIndex
                    }
                    
                    instruction = .line(x: lastInstruction.x, y: .nan)
                    positioning = .absolute
                    
                case .relativeVerticalLine:
                    instruction = .line(x: currentPoint.x, y: currentPoint.y)
                    positioning = .relative
                    argumentPosition = 1
                    singleValue = true
                    
                case .bezierCurve:
                    instruction = .bezierCurve(x: .nan, y: .nan, cx1: .nan, cy1: .nan, cx2: .nan, cy2: .nan)
                    positioning = .absolute
                    
                case .relativeBezierCurve:
                    instruction = .bezierCurve(x: currentPoint.x, y: currentPoint.y, cx1: currentPoint.x, cy1: currentPoint.y, cx2: currentPoint.x, cy2: currentPoint.y)
                    positioning = .relative
                    argumentPosition = 2
                    
                case .smoothBezierCurve:
                    guard let lastInstruction = output.last else {
                        throw Instruction.Error.invalidInstructionIndex
                    }
                    
                    guard let lastControlPoint = lastInstruction.lastControlPoint else {
                        throw Instruction.Error.invalidInstructionIndex
                    }
                    
                    instruction = .bezierCurve(x: .nan, y: .nan, cx1: lastControlPoint.x, cy1: lastControlPoint.y, cx2: .nan, cy2: .nan)
                    positioning = .absolute
                    
                case .relativeSmoothBezierCurve:
                    guard let lastInstruction = output.last else {
                        throw Instruction.Error.relativeInstruction
                    }
                    
                    guard let lastControlPoint = lastInstruction.lastControlPointMirror else {
                        throw Instruction.Error.controlPoint
                    }
                    
                    instruction = .bezierCurve(x: currentPoint.x, y: currentPoint.y, cx1: lastControlPoint.x, cy1: lastControlPoint.y, cx2: currentPoint.x, cy2: currentPoint.y)
                    positioning = .relative
                    argumentPosition = 4
                    
                case .quadraticCurve:
                    instruction = .quadraticCurve(x: .nan, y: .nan, cx: .nan, cy: .nan)
                    positioning = .absolute
                    
                case .relativeQuadraticCurve:
                    instruction = .quadraticCurve(x: currentPoint.x, y: currentPoint.y, cx: currentPoint.x, cy: currentPoint.y)
                    positioning = .relative
                    argumentPosition = 2
                    
                case .smoothQuadraticCurve:
                    guard let lastInstruction = output.last else {
                        throw Instruction.Error.invalidInstructionIndex
                    }
                    
                    guard let lastControlPoint = lastInstruction.lastControlPoint else {
                        throw Instruction.Error.invalidInstructionIndex
                    }
                    
                    instruction = .quadraticCurve(x: .nan, y: .nan, cx: lastControlPoint.x, cy: lastControlPoint.y)
                    positioning = .absolute
                    
                case .relativeSmoothQuadraticCurve:
                    guard let lastInstruction = output.last else {
                        throw Instruction.Error.relativeInstruction
                    }
                    
                    guard let lastControlPoint = lastInstruction.lastControlPointMirror else {
                        throw Instruction.Error.controlPoint
                    }
                    
                    instruction = .quadraticCurve(x: currentPoint.x, y: currentPoint.y, cx: lastControlPoint.x, cy: lastControlPoint.y)
                    positioning = .relative
                    argumentPosition = 0
                    
                case .close, .relativeClose:
                    output.append(.close)
                    
                    // break the loop and begin again.
                    instruction = nil
                    currentPoint = pathOrigin
                }
            } else if let value = Float(element) {
                // Process value
                
                if let currentInstruction = instruction {
                    switch currentInstruction {
                    case .move(let x, let y):
                        switch positioning {
                        case .absolute:
                            if x.isNaN {
                                instruction? = .move(x: value, y: y)
                            } else if y.isNaN {
                                instruction? = .move(x: x, y: value)
                            }
                        case .relative:
                            switch argumentPosition {
                            case 0:
                                instruction = try currentInstruction.adjusting(relativeValue: value, at: argumentPosition)
                                argumentPosition += 1
                            case 1:
                                instruction = try currentInstruction.adjusting(relativeValue: value, at: argumentPosition)
                                argumentPosition = -1
                            default:
                                break
                            }
                        }
                    case .line(let x, let y):
                        switch positioning {
                        case .absolute:
                            if x.isNaN {
                                instruction? = .line(x: value, y: y)
                            } else if y.isNaN {
                                instruction? = .line(x: x, y: value)
                            }
                        case .relative:
                            switch argumentPosition {
                            case 0:
                                instruction = try currentInstruction.adjusting(relativeValue: value, at: argumentPosition)
                                if singleValue {
                                    argumentPosition = -1
                                    singleValue = false
                                } else {
                                    argumentPosition += 1
                                }
                            case 1:
                                instruction = try currentInstruction.adjusting(relativeValue: value, at: argumentPosition)
                                argumentPosition = -1
                            default:
                                break
                            }
                        }
                    case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
                        switch positioning {
                        case .absolute:
                            if cx1.isNaN {
                                instruction? = .bezierCurve(x: x, y: y, cx1: value, cy1: cy1, cx2: cx2, cy2: cy2)
                            } else if cy1.isNaN {
                                instruction? = .bezierCurve(x: x, y: y, cx1: cx1, cy1: value, cx2: cx2, cy2: cy2)
                            } else if cx2.isNaN {
                                instruction? = .bezierCurve(x: x, y: y, cx1: cx1, cy1: cy1, cx2: value, cy2: cy2)
                            } else if cy2.isNaN {
                                instruction? = .bezierCurve(x: x, y: y, cx1: cx1, cy1: cy1, cx2: cx2, cy2: value)
                            } else if x.isNaN {
                                instruction? = .bezierCurve(x: value, y: y, cx1: cx1, cy1: cy1, cx2: cx2, cy2: cy2)
                            } else if y.isNaN {
                                instruction? = .bezierCurve(x: x, y: value, cx1: cx1, cy1: cy1, cx2: cx2, cy2: cy2)
                            }
                        case .relative:
                            switch argumentPosition {
                            case 0, 2...4:
                                instruction = try currentInstruction.adjusting(relativeValue: value, at: argumentPosition)
                                argumentPosition += 1
                            case 1:
                                instruction = try currentInstruction.adjusting(relativeValue: value, at: argumentPosition)
                                argumentPosition = -1
                            case 5:
                                instruction = try currentInstruction.adjusting(relativeValue: value, at: argumentPosition)
                                argumentPosition = 0
                            default:
                                break
                            }
                        }
                    case .quadraticCurve(let x, let y, let cx, let cy):
                        switch positioning {
                        case .absolute:
                            if cx.isNaN {
                                instruction? = .quadraticCurve(x: x, y: y, cx: value, cy: cy)
                            } else if cy.isNaN {
                                instruction? = .quadraticCurve(x: x, y: y, cx: cx, cy: value)
                            } else if x.isNaN {
                                instruction? = .quadraticCurve(x: value, y: y, cx: cx, cy: cy)
                            } else if y.isNaN {
                                instruction? = .quadraticCurve(x: x, y: value, cx: cx, cy: cy)
                            }
                        case .relative:
                            switch argumentPosition {
                            case 0, 2:
                                instruction = try currentInstruction.adjusting(relativeValue: value, at: argumentPosition)
                                argumentPosition += 1
                            case 1:
                                instruction = try currentInstruction.adjusting(relativeValue: value, at: argumentPosition)
                                argumentPosition = -1
                            case 3:
                                instruction = try currentInstruction.adjusting(relativeValue: value, at: argumentPosition)
                                argumentPosition = 0
                            default:
                                break
                            }
                        }
                    case .circle, .rectangle, .close:
                        break
                    }
                    
                } else {
                    // New Instruction, using the last prefix
                    
                    guard let lastInstruction = output.last else {
                        throw Instruction.Error.invalidValueCount
                    }
                    
                    switch lastInstruction {
                    case .move:
                        switch positioning {
                        case .absolute:
                            instruction = .move(x: value, y: .nan)
                        case .relative:
                            instruction = .move(x: lastInstruction.x, y: lastInstruction.y)
                            instruction = try instruction!.adjusting(relativeValue: value, at: 0)
                            argumentPosition = 1
                        }
                    case .line:
                        switch positioning {
                        case .absolute:
                            instruction = .line(x: value, y: .nan)
                        case .relative:
                            instruction = .line(x: lastInstruction.x, y: lastInstruction.y)
                            instruction = try instruction!.adjusting(relativeValue: value, at: 0)
                            argumentPosition = 1
                        }
                    case .bezierCurve:
                        switch positioning {
                        case .absolute:
                            instruction = .bezierCurve(x: .nan, y: .nan, cx1: value, cy1: .nan, cx2: .nan, cy2: .nan)
                        case .relative:
                            guard case let .bezierCurve(x, y, cx1, cy1, cx2, cy2) = lastInstruction else {
                                throw Instruction.Error.relativeInstruction
                            }
                            
                            instruction = .bezierCurve(x: x, y: y, cx1: cx1, cy1: cy1, cx2: cx2, cy2: cy2)
                            instruction = try instruction!.adjusting(relativeValue: value, at: 2)
                            argumentPosition = 3
                        }
                    case .quadraticCurve:
                        switch positioning {
                        case .absolute:
                            instruction = .quadraticCurve(x: .nan, y: .nan, cx: value, cy: .nan)
                        case .relative:
                            guard case let .quadraticCurve(x, y, cx, cy) = lastInstruction else {
                                throw Instruction.Error.relativeInstruction
                            }
                            
                            instruction = .quadraticCurve(x: x, y: y, cx: cx, cy: cy)
                            instruction = try instruction!.adjusting(relativeValue: value, at: 2)
                            argumentPosition = 3
                        }
                    case .circle, .rectangle, .close:
                        break
                    }
                }
                
                if let currentInstruction = instruction, currentInstruction.isComplete {
                    switch positioning {
                    case .relative:
                        guard argumentPosition == -1 else {
                            break
                        }
                        
                        fallthrough
                    case .absolute:
                        output.append(currentInstruction)
                        instruction = nil
                        currentPoint = currentInstruction.point
                        
                        if pathOrigin.x.isNaN || pathOrigin.y.isNaN {
                            pathOrigin = currentInstruction.point
                        }
                    }
                }
            } else {
                print("What? \(element)")
            }
        }
        
        if let activeInstruction = instruction, activeInstruction.isComplete {
            output.append(activeInstruction)
            if pathOrigin.x.isNaN || pathOrigin.y.isNaN {
                pathOrigin = activeInstruction.point
            }
        }
        
        if let last = output.last {
            switch last {
            case .close:
                break
            default:
                output.append(.close)
            }
        }
        
        return output
    }
}

// MARK: - InstructionSetRepresentable
extension Path: InstructionSetRepresentable {
}

// MARK: - Equatable
extension Path: Equatable {
    public static func == (lhs: Path, rhs: Path) -> Bool {
        do {
            let lhsInstructions = try lhs.instructions()
            let rhsInstructions = try rhs.instructions()
            return lhsInstructions == rhsInstructions
        } catch {
            return false
        }
    }
}

// MARK: - Private
private extension Path {
    /// Deconstructs the `data` string into its component parts.
    func dataComponents() -> [String] {
        var output: [String] = []
        
        var component: String = ""
        
        data.unicodeScalars.forEach { (character) in
            // Account for exponential notation
            if character == "e" {
                component.append(String(character))
                return
            }
            
            if CharacterSet.letters.contains(character) {
                if !component.isEmpty {
                    output.append(component)
                    component = ""
                }
                
                output.append(String(character))
                
                return
            }
            
            if CharacterSet.whitespaces.contains(character) {
                if !component.isEmpty {
                    output.append(component)
                    component = ""
                }
                
                return
            }
            
            if CharacterSet(charactersIn: ",").contains(character) {
                if !component.isEmpty {
                    output.append(component)
                    component = ""
                }
                
                return
            }
            
            if CharacterSet(charactersIn: "-").contains(character) {
                // Account for exponential notation
                if !component.isEmpty && component.last != "e" {
                    output.append(component)
                    component = ""
                }
                
                component.append(String(character))
                
                return
            }
            
            if CharacterSet(charactersIn: ".").contains(character) {
                component.append(String(character))
                
                return
            }
            
            if CharacterSet.decimalDigits.contains(character) {
                component.append(String(character))
                
                return
            }
            
            print("UNHANDLED CHARACTER: \(character)")
        }
        
        if !component.isEmpty {
            output.append(component)
            component = ""
        }
        
        return output.filter({ !$0.isEmpty })
    }
}
