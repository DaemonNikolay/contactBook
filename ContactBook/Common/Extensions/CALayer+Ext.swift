import UIKit.UIView

extension CALayer {
	struct SketchShadow {
		var color: UIColor = .black
		var alpha: Float = 0.5
		var x: CGFloat = 0
		var y: CGFloat = 0
		var blur: CGFloat = 4
		var spread: CGFloat = 0
	}
	
	func applySketchShadow(_ sketchShadow: SketchShadow) {
		masksToBounds = false
		
		shadowColor = sketchShadow.color.cgColor
		shadowOpacity = sketchShadow.alpha
		shadowOffset = CGSize(width: sketchShadow.x, height: sketchShadow.y)
		shadowRadius = sketchShadow.blur / 2.0
		
		if sketchShadow.spread == 0 {
			shadowPath = nil
		} else {
			let dx = -sketchShadow.spread
			let rect = bounds.insetBy(dx: dx, dy: dx)
			
			shadowPath = UIBezierPath(rect: rect).cgPath
		}
	}
}
