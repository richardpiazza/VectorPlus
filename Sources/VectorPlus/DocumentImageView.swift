import SwiftSVG
#if canImport(UIKit)
import UIKit

@IBDesignable public class DocumentImageView: UIImageView {
    
    public var width: CGFloat {
        return CGFloat(document.originalSize.width)
    }
    public var height: CGFloat {
        return CGFloat(document.originalSize.height)
    }
    
    open var svg: SVG = SVG() {
        didSet {
            updateSubviews()
        }
    }
    
    public var widthToHeightAspectRatio: CGFloat {
        guard width != .nan, width > 0.0 else {
            return 0.0
        }
        
        guard height != .nan, height > 0.0 else {
            return 0.0
        }
        
        return width / height
    }
    
    public var heightToWidthAspectRatio: CGFloat {
        guard height != .nan, height > 0.0 else {
            return 0.0
        }
        
        guard width != .nan, width > 0.0 else {
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
        image = svg.uiImage(size: bounds.size)
    }
}

#endif
