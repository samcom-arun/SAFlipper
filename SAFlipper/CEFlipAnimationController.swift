
import UIKit

class CEFlipAnimationController: CEReversibleAnimationController {
    
    open override func animateTransition(_ transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, from fromView: UIView, to toView: UIView) {
        // Add the toView to the container
        let containerView: UIView? = transitionContext.containerView
        containerView?.addSubview(toView)
        containerView?.sendSubview(toBack: toView)
        // Add a perspective transform
        var transform = CATransform3DIdentity as CATransform3D
        transform.m34 = -0.002
        containerView?.layer.sublayerTransform = transform
        // Give both VCs the same start frame
        let initialFrame: CGRect = transitionContext.initialFrame(for: fromVC)
        fromView.frame = initialFrame
        toView.frame = initialFrame
        // create two-part snapshots of both the from- and to- views
        let toViewSnapshots = createSnapshots(toView, afterScreenUpdates: true)
        var flippedSectionOfToView: UIView? = (toViewSnapshots[!reverse ? 0 : 1] as! UIView)
        let fromViewSnapshots = createSnapshots(fromView, afterScreenUpdates: false)
        var flippedSectionOfFromView = fromViewSnapshots[!reverse ? 1 : 0] as? UIView
        // replace the from- and to- views with container views that include gradients
        flippedSectionOfFromView = addShadow(to: flippedSectionOfFromView!, reverse: reverse)
        let flippedSectionOfFromViewShadow = flippedSectionOfFromView?.subviews[1]
        flippedSectionOfFromViewShadow?.alpha = 0.0
        flippedSectionOfToView = addShadow(to: flippedSectionOfToView!, reverse: !reverse)
        let flippedSectionOfToViewShadow: UIView? = flippedSectionOfToView?.subviews[1]
        flippedSectionOfToViewShadow?.alpha = 1.0
        // change the anchor point so that the view rotate around the correct edge
        updateAnchorPointAndOffset(CGPoint(x: !reverse ? 0.0 : 1.0, y: 0.5), view: flippedSectionOfFromView!)
        updateAnchorPointAndOffset(CGPoint(x: !reverse ? 1.0 : 0.0, y: 0.5), view: flippedSectionOfToView!)
        // rotate the to- view by 90 degrees, hiding it
        flippedSectionOfToView?.layer.transform = rotate(CGFloat(!reverse ? Double.pi/2 : -(Double.pi/2)))
        // animate
        let duration: TimeInterval = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [], animations: {() -> Void in
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {() -> Void in
                flippedSectionOfFromView?.layer.transform = self.rotate(CGFloat(!self.reverse ? -(Double.pi/2) : (Double.pi/2)))
                flippedSectionOfFromViewShadow?.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {() -> Void in
                flippedSectionOfToView?.layer.transform = self.rotate(!self.reverse ? 0.001 : -0.001)
                flippedSectionOfToViewShadow?.alpha = 0.0
            })
        }, completion: {(_ finished: Bool) -> Void in
            if transitionContext.transitionWasCancelled {
                self.removeOtherViews(fromView)
            } else {
                self.removeOtherViews(toView)
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func removeOtherViews(_ viewToKeep: UIView) {
        let containerView: UIView? = viewToKeep.superview
        for view: UIView in (containerView?.subviews)! {
            if view != viewToKeep {
                view.removeFromSuperview()
            }
        }
    }
    
    func addShadow(to view: UIView, reverse: Bool) -> UIView {
        let containerView: UIView? = view.superview
        let viewWithShadow = UIView(frame: view.frame)
        containerView?.insertSubview(viewWithShadow, aboveSubview: view)
        view.removeFromSuperview()
        let shadowView = UIView(frame: viewWithShadow.bounds)
        let gradient = CAGradientLayer()
        gradient.frame = shadowView.bounds
        gradient.colors = [(UIColor(white: 0.0, alpha: 0.0).cgColor), (UIColor(white: 0.0, alpha: 0.5).cgColor)]
        gradient.startPoint = CGPoint(x: reverse ? 0.0 : 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: reverse ? 1.0 : 0.0, y: 0.0)
        shadowView.layer.insertSublayer(gradient, at: 1)
        view.frame = view.bounds
        viewWithShadow.addSubview(view)
        viewWithShadow.addSubview(shadowView)
        return viewWithShadow
    }
    
    func createSnapshots(_ view: UIView, afterScreenUpdates afterUpdates: Bool) -> [Any] {
        let containerView: UIView? = view.superview
        // snapshot the left-hand side of the view
        var snapshotRegion = CGRect(x: 0, y: 0, width: view.frame.size.width / 2, height: view.frame.size.height)
        let leftHandView: UIView? = view.resizableSnapshotView(from: snapshotRegion, afterScreenUpdates: afterUpdates, withCapInsets: UIEdgeInsets.zero)
        leftHandView?.frame = snapshotRegion
        containerView?.addSubview(leftHandView!)
        // snapshot the right-hand side of the view
        snapshotRegion = CGRect(x: view.frame.size.width / 2, y: 0, width: view.frame.size.width / 2, height: view.frame.size.height)
        let rightHandView: UIView? = view.resizableSnapshotView(from: snapshotRegion, afterScreenUpdates: afterUpdates, withCapInsets: UIEdgeInsets.zero)
        rightHandView?.frame = snapshotRegion
        containerView?.addSubview(rightHandView!)
        containerView?.sendSubview(toBack: view)
        return [leftHandView!, rightHandView!]
    }
    
    func updateAnchorPointAndOffset(_ anchorPoint: CGPoint, view: UIView) {
        view.layer.anchorPoint = anchorPoint
        let xOffset: Float = Float(anchorPoint.x - 0.5)
        let aValue = (xOffset * Float(view.frame.size.width))
        view.frame = view.frame.offsetBy(dx: CGFloat(aValue), dy: 0)
    }
    
    func rotate(_ angle: CGFloat) -> CATransform3D {
        return CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0)
    }
}


