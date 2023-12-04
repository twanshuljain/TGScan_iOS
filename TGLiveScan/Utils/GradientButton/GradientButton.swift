import UIKit
import Foundation
class CustomButtonGradiant: UIButton {
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
        gradientLayer.colors = [UIColor.init(named: "StartGradient")?.cgColor ?? UIColor.self, UIColor.init(named: "EndGradient")?.cgColor ?? UIColor.self]
        gradientLayer.cornerRadius = 5
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
    func setTitles(text: String, font: UIFont, tintColour: UIColor) {
        self.setTitle(text, for: .normal)
        self.tintColor = tintColour
        self.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .sixteen)
    }
}
extension CustomButtonGradiant {
    func addRightIcon(image: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        let length = CGFloat(24)
        titleEdgeInsets.right += length
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 5),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: length),
            imageView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
    func addLeftIcon(image: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
//        let length = CGFloat(22)
//        titleEdgeInsets.left += length
        NSLayoutConstraint.activate([
            //imageView.trailingAnchor.constraint(equalTo: self.titleLabel!.leadingAnchor, constant: -10),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
//            imageView.widthAnchor.constraint(equalToConstant: length),
//            imageView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
    
    func removeLeftIcon() {
        self.subviews.forEach { view in
            if view is UIImageView {
                view.removeFromSuperview()
            }
        }
    }
}
class CustomButtonNormal: UIButton {
    func setTitles(text: String, font: UIFont, tintColour: UIColor , textColour : UIColor) {
        self.setTitleColor(textColour, for: .normal)
        self.setTitle(text, for: .normal)
        self.tintColor = tintColour
        self.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .sixteen)
    }
}
extension CustomButtonNormal {
    func addRightIcon(image: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        let length = CGFloat(15)
        titleEdgeInsets.right += length
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: length),
            imageView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
    func addLeftIcon(image: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        let length = CGFloat(24)
        titleEdgeInsets.left += length
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: self.titleLabel!.leadingAnchor, constant: -4),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: length),
            imageView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
}
class CustomButtonNormalWithBorder: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cornerRadius = 10
        self.borderWidth = 1.5
        self.borderColor = UIColor(named: "TGBlue")
        self.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .sixteen)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.cornerRadius = 10
        self.borderWidth = 1.5
        self.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .sixteen)
    }
    func setTitles(text: String, textColour : UIColor , borderColour : UIColor) {
        self.setTitleColor(textColour, for: .normal)
        self.borderColor = borderColour
        self.setTitle(text, for: .normal)
    }
    func setTitles(text: String, font: UIFont,
                   textColour: UIColor, borderColour : UIColor) {
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColour, for: .normal)
        self.borderColor = borderColour
        self.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .sixteen)
    }
    func addRightIcon(image: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        let length = CGFloat(20)
        titleEdgeInsets.right += length
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: length),
            imageView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
}
