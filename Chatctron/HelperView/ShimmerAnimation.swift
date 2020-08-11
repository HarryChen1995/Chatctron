import UIKit
extension UIView {
  
  
  func startShimmeringAnimation() {
    
    backgroundColor = .primaryColor
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor, UIColor.white.cgColor]
    gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
    
    
      gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
      gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
      

    
    gradientLayer.locations =  [0.35, 0.50, 0.65]
    self.layer.mask = gradientLayer
    let animation = CABasicAnimation(keyPath: "locations")
    animation.fromValue = [0.0, 0.1, 0.2]
    animation.toValue = [0.8, 0.9, 1.0]
    animation.duration = 1
    animation.repeatCount = Float.infinity
    gradientLayer.add(animation, forKey: "locations")
  }
  
  func stopShimmeringAnimation() {
    backgroundColor = .clear
    self.layer.mask = nil
  }
  
}

