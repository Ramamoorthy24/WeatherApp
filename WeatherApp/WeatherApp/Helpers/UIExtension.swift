//
//  MAView.swift


import UIKit
import CoreMedia

@IBDesignable
class CustomView: UIView {
    
    @IBInspectable
    var circleRadius: CGFloat = 7 { didSet { applySemiCircle() } }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if tag != 0 {
            applySemiCircle()
        }
    }
    
    
    private func applySemiCircle() {
        let path = UIBezierPath()
        path.move(to: bounds.origin)
        let center = CGPoint(x: bounds.origin.x + bounds.size.width / 2.0, y: bounds.origin.y)
        path.addArc(withCenter: center, radius: circleRadius, startAngle: .pi, endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y))
        path.addLine(to: CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y + bounds.size.height))
        path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height))
        path.close()
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    
    @IBInspectable var BGColor: String = "BackgroundColor" {
        didSet {
            self.backgroundColor = Color(rawValue: BGColor)?.value ?? Color.backgroundColor.value
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColorString: String = "PrimaryColor" {
        didSet {
            layer.borderColor = Color(rawValue: borderColorString)?.value.cgColor ?? UIColor.clear.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
                layer.masksToBounds = false
            } else {
                layer.shadowColor = nil
            }
        }
    }
}


enum ViewShadowLocation: String {
    case bottom
    case top
    case left
    case right
    case all
}

extension UIView {
    func addShadow(location: ViewShadowLocation, color: UIColor = .black, opacity: Float = 0.25, radius: CGFloat = 2.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 5), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -1.0), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -5, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 5, height: 0), color: color, opacity: opacity, radius: radius)
        case .all:
            addShadow(offset: .zero, color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .green, opacity: Float = 1.0, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    func halfRoundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension CustomView {
    
    func addDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor =  UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 2.0
    }
}

@IBDesignable
class CustomLabel: UILabel {
    
    @IBInspectable var isRounded: Bool = false{
        didSet {
            if isRounded {
                self.layer.cornerRadius = self.frame.size.width / 2
                self.clipsToBounds = true
            }
        }
    }
    
    @IBInspectable var TextFont: String = "LargeTitle" {
        didSet {
            self.font = Font(rawValue: TextFont)?.value ?? Font.Headline.value
        }
    }
    
    @IBInspectable var TxtColor: String = "PrimaryLabelColor" {
        didSet {
            self.textColor = Color(rawValue: TxtColor)?.value ?? Color.primaryLabelColor.value
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    
    @IBInspectable
    var rotation: Int {
            get {
                return 0
            } set {
                let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
                self.transform = CGAffineTransform(rotationAngle: radians)
            }
        }
    
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    @IBInspectable
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    @IBInspectable
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
    
    @IBInspectable
    var borderColorString: String = "PrimaryColor" {
        didSet {
            layer.borderColor = Color(rawValue: borderColorString)?.value.cgColor ?? UIColor.clear.cgColor
        }
    }
    
    @IBInspectable var BGColor: String = "PrimaryColor" {
        didSet {
            self.backgroundColor = Color(rawValue: BGColor)?.value ?? UIColor.clear
        }
    }
    
}

@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var TextFont: String = "LargeTitle" {
        didSet {
            self.font = Font(rawValue: TextFont)?.value ?? Font.Headline.value
        }
    }
    
    @IBInspectable var TxtColor: String = "PrimaryLabelColor" {
        didSet {
            self.textColor = Color(rawValue: TxtColor)?.value ?? Color.primaryLabelColor.value
        }
    }
    @IBInspectable var PlaceHolderColor: String = "placeHolderColor" {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: Color(rawValue: PlaceHolderColor)?.value ?? Color.placeHolderColor.value])
        }
    }
    
    @IBInspectable var isUnderline: Bool = false {
        didSet {
            if isUnderline {
                self.useUnderline()
            }
        }
    }
    
    @IBInspectable var insetX: CGFloat = 6 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var insetY: CGFloat = 6 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
        
    func addDoneButtonOnKeyboard(title: String)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    
    
    func addInputAccessoryView(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
}

extension UITextField {
    
    func useUnderline() {
        
        let border = CALayer()
        let borderWidth = CGFloat(0.5)
        border.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
}

extension UITextView {
    
    func useUnderline() {
        
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
}

@IBDesignable
class CustomTextView: UITextView {
    
    @IBInspectable var TextFont: String = "LargeTitle" {
        didSet {
            self.font = Font(rawValue: TextFont)?.value ?? Font.Headline.value
        }
    }
    @IBInspectable var TxtColor: String = "PrimaryLabelColor" {
        didSet {
            self.textColor = Color(rawValue: TxtColor)?.value ?? Color.primaryLabelColor.value
        }
    }
    
    @IBInspectable var isUnderline: Bool = false {
        didSet {
            if isUnderline {
                self.useUnderline()
            }
        }
    }
    
    func addInputAccessoryView(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    
}

extension UIButton {
    
    func useUnderline() {
        let bottomBorder = UIView(frame: CGRect(x: 0, y: frame.size.height - 1.0, width: bounds.size.width, height: 1.0))
        bottomBorder.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        self.addSubview(bottomBorder)
        
    }
}


@IBDesignable
class CustomButton: UIButton {
    
    
    @IBInspectable var TextFont: String = "Subhead" {
        didSet {
            self.titleLabel?.font = Font(rawValue: TextFont)?.value ?? Font.Headline.value
        }
    }
    
    @IBInspectable var normalState: String = "BackgroundColor" {
        didSet {
            self.setTitleColor(Color(rawValue: normalState)?.value ?? Color.primaryLabelColor.value, for: .normal)
        }
    }
    
    @IBInspectable var selectedState: String = "BackgroundColor" {
        didSet {
            self.setTitleColor(Color(rawValue: selectedState)?.value ?? Color.primaryLabelColor.value, for: .selected)
        }
    }
    
    @IBInspectable var normalStateText: String = "" {
        didSet {
            self.setTitle(normalStateText, for: .normal)
        }
    }
    
    @IBInspectable var selectedStateText: String = "" {
        didSet {
            self.setTitle(selectedStateText, for: .selected)
        }
    }
    
    @IBInspectable var normalStateBGColor: String = "none"
    
    @IBInspectable var selectedBGColor: String = "none"
    
    
    
    @IBInspectable var TxtColor: String = "PrimaryLabelColor" {
        didSet {
            self.setTitleColor(Color(rawValue: TxtColor)?.value ?? Color.primaryLabelColor.value, for: .normal)
        }
    }
    @IBInspectable var BGColor: String = "BackgroundColor" {
        didSet {
            self.backgroundColor = Color(rawValue: BGColor)?.value ?? UIColor.clear
        }
    }
    
    @IBInspectable var buttonTintColor: String? {
        didSet {
            self.tintColor = Color(rawValue: buttonTintColor ?? "")?.value ?? Color.primaryColor.value
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var ShadowColor: String = "buttonShadow" {
        didSet {
            self.layer.masksToBounds = false
            self.layer.shadowColor =  Color(rawValue: ShadowColor)?.value.cgColor ?? UIColor.clear.cgColor
            self.layer.shadowOffset = CGSize.zero
            self.layer.shadowRadius = 5.0
            self.layer.shadowOpacity = 0.3
        }
    }
    
    @IBInspectable
    var opacity: Float {
        get {
            return layer.opacity
        }
        set {
            layer.opacity = newValue
        }
    }
    
    @IBInspectable
    var alignTitleWithImagePaddingAtBottom: Float = 0.0 {
        didSet {
            alignImageAndTitleVertically(padding: 6.0)
        }
    }
    
    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        setNeedsLayout()
        layoutIfNeeded()
        let txt = isSelected ? "Following" : "Follow"
        let size = txt.size(withAttributes: [.font: titleLabel!.font])
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        //        let totalwidth = imageSize.width + size.width
        let totalwidth = self.frame.width
        var moveImage = -totalwidth / 2 - imageSize.width / 2
        moveImage = isSelected ? moveImage - 15 : moveImage + 4
        let movetext = isSelected ? -imageSize.width : -imageSize.width - 4
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: moveImage
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: movetext,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
    
    let gradientLayer = CAGradientLayer()
    
    
    @IBInspectable
    var startGradientColor: UIColor? {
        didSet {
            setGradient(startGradientColor: startGradientColor, midGradientColor: midGradientColor, endGradientColor: endGradientColor)
        }
    }
    @IBInspectable
    var midGradientColor: UIColor? {
        didSet {
            setGradient(startGradientColor: startGradientColor, midGradientColor: midGradientColor, endGradientColor: endGradientColor)
        }
    }
    @IBInspectable
    var endGradientColor: UIColor? {
        didSet {
            setGradient(startGradientColor: startGradientColor, midGradientColor: midGradientColor, endGradientColor: endGradientColor)
        }
    }
    
    private func setGradient(startGradientColor: UIColor?,midGradientColor:UIColor?, endGradientColor: UIColor?) {
        if let startGradientColor = startGradientColor,let midGradientColor = midGradientColor,  let endGradientColor = endGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [startGradientColor.cgColor, midGradientColor.cgColor ,endGradientColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
 
}

extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

@IBDesignable
class CustomImageView: UIImageView {
    
    @IBInspectable var isRounded: Bool = false{
        didSet {
            if isRounded {
                self.layer.cornerRadius = self.frame.size.width / 2
                self.clipsToBounds = true
            }
        }
    }
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
    }
}

@IBDesignable
class CustomBarButtonItem: UIBarButtonItem {
    
    @IBInspectable var buttonTintColor: String? {
        didSet {
            self.tintColor = Color(rawValue: buttonTintColor ?? "")?.value ?? Color.primaryColor.value
        }
    }
}

@IBDesignable
class CustomTabBar: UITabBar {
    @IBInspectable var tintColorText: String = "PrimaryColor" {
        didSet {
            self.tintColor = Color(rawValue: tintColorText)?.value ?? Color.primaryColor.value
        }
    }
}

extension UIApplication {
    
    var screenShot: UIImage?  {
        return keyWindow?.layer.screenShot
    }
}

extension CALayer {
    
    var screenShot: UIImage?  {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshot
        }
        return nil
    }
}
extension UIApplication {
    
    static func topViewController() -> UIViewController? {
        guard var top = shared.keyWindow?.rootViewController else {
            return nil
        }
        while let next = top.presentedViewController {
            top = next
        }
        return top
    }
}

extension UIView {
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
}

public extension UIButton {
    
    func alignTextBelow(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
}
public extension UIView {
    
    public func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, !isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let newImg = snapshotImage else {
            return nil
        }
        guard let imageData = newImg.pngData() else {
            return nil
        }
        let pngsnapshotImage =  UIImage.init(data: imageData)
        return pngsnapshotImage
    }
    
    public func snapshotView() -> UIView? {
        if let snapshotImage = snapshotImage() {
            return UIImageView(image: snapshotImage)
        } else {
            return nil
        }
    }
    
}


extension UIImage {
    
    static func from(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let baseAddresses = CVPixelBufferGetBaseAddress(imageBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: baseAddresses,
            width: CVPixelBufferGetWidth(imageBuffer),
            height: CVPixelBufferGetHeight(imageBuffer),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(imageBuffer),
            space: colorSpace,
            bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue
        )
        let quartzImage = context?.makeImage()
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        if let quartzImage = quartzImage {
            let image = UIImage(cgImage: quartzImage)
            return image
        }
        
        return nil
    }
    
}


extension UIBezierPath {
    convenience init(roundedRect rect: CGRect, topLeftRadius r1: CGFloat, topRightRadius r2: CGFloat, bottomRightRadius r3: CGFloat, bottomLeftRadius r4: CGFloat) {
        let left  = CGFloat(Double.pi)
        let up    = CGFloat(1.5*Double.pi)
        let down  = CGFloat(Double.pi / 2)
        let right = CGFloat(0.0)
        self.init()
        
        addArc(withCenter: CGPoint(x: rect.minX + r1, y: rect.minY + r1), radius: r1, startAngle: left,  endAngle: up,    clockwise: true)
        addArc(withCenter: CGPoint(x: rect.maxX - r2, y: rect.minY + r2), radius: r2, startAngle: up,    endAngle: right, clockwise: true)
        addArc(withCenter: CGPoint(x: rect.maxX - r3, y: rect.maxY - r3), radius: r3, startAngle: right, endAngle: down,  clockwise: true)
        addArc(withCenter: CGPoint(x: rect.minX + r4, y: rect.maxY - r4), radius: r4, startAngle: down,  endAngle: left,  clockwise: true)
        close()
    }
}
extension UILabel {
    func lblShadow(textColor: UIColor ,shadowColor: UIColor , radius: CGFloat, opacity: Float){
        self.textColor = textColor
        
        self.layer.masksToBounds = false
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}


extension UIView {
    
    func getTextFieldsInView(view: UIView) -> [UITextField] {
        
        var totalTextFields = [UITextField]()
        
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                totalTextFields += [textField]
            } else {
                totalTextFields += getTextFieldsInView(view: subview)
            }
        }
        
        return totalTextFields
    }
    
    func getSelectedTextField() -> UITextField? {
        
        let totalTextFields = getTextFieldsInView(view: self)
        
        for textField in totalTextFields{
            if textField.isFirstResponder{
                return textField
            }
        }
        
        return nil
        
    }
    
}

