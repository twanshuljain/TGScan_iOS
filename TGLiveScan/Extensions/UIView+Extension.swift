//
//  UIView+Extension.swift
//  TicketGateway
//
//  Created by Apple  on 11/04/23.
import UIKit

extension UIView {
     class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as! T
    }

    func setTextFiledBorder() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9098039216, blue: 0.9254901961, alpha: 1)
        layer.backgroundColor = .none
    }
    
    
    func createDottedLine(width: CGFloat, color: CGColor, dashPattern: [NSNumber]) {
       let caShapeLayer = CAShapeLayer()
       caShapeLayer.strokeColor = color
       caShapeLayer.lineWidth = width
       caShapeLayer.lineDashPattern = dashPattern
       let cgPath = CGMutablePath()
       let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
       cgPath.addLines(between: cgPoint)
       caShapeLayer.path = cgPath
       layer.addSublayer(caShapeLayer)
      }
  
    func addShadow() {
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2.5)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 10
    }

    func showAnimated() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
            self.center.y -= self.bounds.height
            self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }

    func hideAnimated() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
            self.center.y += self.bounds.height
            self.layoutIfNeeded()
        }, completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }

    func updateViewAnimated( _ cns: NSLayoutConstraint, _ show: Bool) {
        if show {
            UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseIn],
                           animations: {
                cns.constant = 50
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseIn],
                           animations: {
                cns.constant = -1000
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius,
                                                    height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    func lock() {
        if let _ = viewWithTag(10) {
            // View is already locked
        } else {
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = .white.withAlphaComponent(0.20)
            lockView.tag = 10
            lockView.alpha = 0.0
            let activity = UIActivityIndicatorView()
            activity.hidesWhenStopped = true
            activity.center = lockView.center
            activity.color = .white
            lockView.addSubview(activity)
            activity.startAnimating()
            addSubview(lockView)
            UIView.animate(withDuration: 0.2, animations: {
                lockView.alpha = 1.0
            })
        }
    }

    func unlock() {
        if let lockView = viewWithTag(10) {
            UIView.animate(withDuration: 0.2, animations: {
                lockView.alpha = 0.0
            }, completion: { _ in
                lockView.removeFromSuperview()
            })
        }
    }

    func fadeOut(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }

    func fadeIn(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }

    class func viewFromNibName(_ name: String) -> UIView? {
        let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        return views?.first as? UIView
    }

    func animateLineView(_ btn: UIButton, _ cns: NSLayoutConstraint, _ viewLine: UIView) {
        UIView.animate(withDuration: 0.15) {
            var frame = viewLine.frame
            frame.origin.x = btn.frame.origin.x
            cns.constant = btn.frame.origin.x
            viewLine.frame = frame
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var leftBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = UIColor(cgColor: layer.borderColor!)
            line.tag = 110
            self.addSubview(line)
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]",
                                                          options: [],
                                                          metrics: metrics,
                                                          views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: views))
        }
    }

    @IBInspectable var topBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]",
                                                          options: [],
                                                          metrics: metrics,
                                                          views: views))
        }
    }

    @IBInspectable var rightBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: bounds.width, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|",
                                                          options: [],
                                                          metrics: metrics,
                                                          views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: views))
        }
    }
    @IBInspectable var bottomBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|",
                                                          options: [],
                                                          metrics: metrics,
                                                          views: views))
        }
    }
    func removeborder() {
        for view in self.subviews {
            if view.tag == 110 {
                view.removeFromSuperview()
            }
        }
    }

    @IBInspectable var isShadow: Bool {
        get {
            return false
        }
        set {
            self.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 3
            self.layer.shadowOpacity = 0.35
            self.layer.masksToBounds = false
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var isTopCorner: Bool {
        get {
            return false
        }
        set {
            self.clipsToBounds = true
            self.layer.cornerRadius = 32
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }

    @IBInspectable
    // Shadow color of view; also inspectable from Storyboard.
    public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    @IBInspectable
    // Shadow offset of view; also inspectable from Storyboard.
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    // Shadow opacity of view; also inspectable from Storyboard.
    public var shadowOpacity: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }

    @IBInspectable
    // Shadow radius of view; also inspectable from Storyboard.
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    // Shadow path of view; also inspectable from Storyboard.
    public var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }

    @IBInspectable
    // Should shadow rasterize of view; also inspectable from Storyboard.
    // cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowShouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }

    @IBInspectable
    // Should shadow rasterize of view; also inspectable from Storyboard.
    // cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowRasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }
    
   

    func setShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        layer.shouldRasterize = true
    }

    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                               y: bounds.maxY - layer.shadowRadius,
                               width: bounds.width,
                               height: layer.shadowRadius)).cgPath
      }
    func addGradientLayer(gradientLayer: CAGradientLayer,
                          colors: [CGColor],
                          location: [NSNumber]) {
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = location
        self.layer.addSublayer(gradientLayer)
    }

    func makeCircular() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
    }

    var safeAreaHeight: CGFloat {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide.layoutFrame.size.height
        }
        return bounds.height
    }

    func dropShadow(color: UIColor = .gray) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
    }

    func captureScreenShot() -> UIImage? {
        let scale = UIScreen.main.scale
        let bounds = self.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, scale)
        if let _ = UIGraphicsGetCurrentContext() {
            self.drawHierarchy(in: bounds, afterScreenUpdates: true)
            let screenShot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenShot
        }
        return nil
    }
       
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return (label.frame.height + 5.0)
    }
    static let loadingViewTag = 1938123987
    static let loadingViewTag1 = 1938123986
    
    //func showLoading(parentView: UIView, style: UIActivityIndicatorView.Style = .large, color: UIColor? = nil, scale: CGFloat = 1) {
    func showLoading(centreToView: UIView) {
        DispatchQueue.main.async {  [weak self] in
            guard let self = self else { return }
            var loaderParentView = self.viewWithTag(UIView.loadingViewTag1)
            if loaderParentView == nil {
                loaderParentView = UIView()
                
            }
            loaderParentView?.tag = 1938123986
            loaderParentView!.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
            self.addSubview(loaderParentView!)
            let style: UIActivityIndicatorView.Style = .large
            let color: UIColor? =  UIColor.setColor(colorType: .tgBlue)
            let scale: CGFloat =  0.9
            
            
            var loading = self.viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
            if loading == nil {
                loading = UIActivityIndicatorView(style: style)
            }
            
            if let color = color {
                loading?.color = color
            }
            loading?.tag = 1938123987
            loading?.contentScaleFactor = scale
            loading?.translatesAutoresizingMaskIntoConstraints = false
            loading?.startAnimating()
            loading?.hidesWhenStopped = true
            loading?.tag = UIView.loadingViewTag
            loaderParentView?.addSubview(loading!)
            loading?.centerYAnchor.constraint(equalTo: centreToView.centerYAnchor).isActive = true
            loading?.centerXAnchor.constraint(equalTo: centreToView.centerXAnchor).isActive = true
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [self] in
            let loading = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
            let loadingParentView = viewWithTag(UIView.loadingViewTag1)
            loading?.stopAnimating()
            loading?.removeFromSuperview()
            loadingParentView?.removeFromSuperview()
        }
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

class customSocialLoginView: UIView {

        func setup() {
            layer.shadowColor = UIColor.lightGray.cgColor
            self.backgroundColor = .white
            layer.shadowOpacity = 0.4
            
             layer.shadowOffset = CGSize(width: 2, height: 2)
            layer.shadowRadius = 10
            layer.cornerRadius = 10
            layer.masksToBounds = false
     }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
class customTopCornerRadiusView: UIView {

        func setup() {
            clipsToBounds = true
            layer.cornerRadius = 20
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
class setBorderView: UIView {

        func setup() {
            layer.shadowColor = UIColor.lightGray.cgColor
            self.backgroundColor = .white
            layer.shadowOpacity = 0.2
            
             layer.shadowOffset = CGSize(width: 2, height: 2)
            layer.shadowRadius = 7.5
            layer.cornerRadius = 7.5
            layer.masksToBounds = false
     }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

class CustomViewGradiant: UIView {
    let gradientLayer = CAGradientLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackGround()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBackGround()
    }
    
    func setBackGround() {
        gradientLayer.colors = [UIColor.init(named: "startviewGra")?.cgColor ?? UIColor.self, UIColor.init(named: "endviewGra")?.cgColor ?? UIColor.self]
        gradientLayer.cornerRadius = 0
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.shouldRasterize = true
        gradientLayer.frame = layer.bounds
        gradientLayer.layoutIfNeeded()
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
    
}
@IBDesignable
class GradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    

    override func draw(_ rect: CGRect) {
            gradientLayer.cornerRadius = 0
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.shouldRasterize = true
            gradientLayer.frame = layer.bounds
            gradientLayer.layoutIfNeeded()
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
       
        layer.addSublayer(gradientLayer)
    }
override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = self.bounds
    gradientLayer.cornerRadius = 20
}
}
@IBDesignable
class GradientViewBg: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    

    override func draw(_ rect: CGRect) {
            gradientLayer.cornerRadius = 0
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.shouldRasterize = true
            gradientLayer.frame = layer.bounds
            gradientLayer.layoutIfNeeded()
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
       
        layer.addSublayer(gradientLayer)
    }
override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = self.bounds
    gradientLayer.cornerRadius = 0
}
}
