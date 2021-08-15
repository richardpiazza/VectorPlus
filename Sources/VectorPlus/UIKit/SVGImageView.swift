import SwiftSVG
import Swift2D
#if canImport(UIKit)
import UIKit

@IBDesignable open class SVGImageView: UIImageView {
    
    public var width: CGFloat {
        return CGFloat(svg.originalSize.width)
    }
    public var height: CGFloat {
        return CGFloat(svg.originalSize.height)
    }
    
    open var svg: SVG = SVG() {
        didSet {
            updateSubviews()
        }
    }
    
    public var widthToHeightAspectRatio: CGFloat {
        guard !width.isNaN, width > 0.0 else {
            return 0.0
        }
        
        guard !height.isNaN, height > 0.0 else {
            return 0.0
        }
        
        return width / height
    }
    
    public var heightToWidthAspectRatio: CGFloat {
        guard !height.isNaN, height > 0.0 else {
            return 0.0
        }
        
        guard !width.isNaN, width > 0.0 else {
            return 0.0
        }
        
        return height / width
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        updateSubviews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateSubviews()
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    public override var bounds: CGRect {
        didSet {
            updateSubviews()
        }
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateSubviews()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateSubviews()
    }
    
    public func updateSubviews() {
        image = svg.uiImage(size: Size(bounds.size))
    }
}

#endif
