
import UIKit

class CEReversibleAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    var reverse = false
    var duration = TimeInterval()
    
    override init() {
        super.init()
        duration = 1.0
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC: UIViewController? = transitionContext.viewController(forKey: .from)
        let toVC: UIViewController? = transitionContext.viewController(forKey: .to)
        let toView: UIView? = toVC?.view
        let fromView: UIView? = fromVC?.view
        animateTransition(transitionContext, fromVC: fromVC!, toVC: toVC!, from: fromView!, to: toView!)
    }
    
    func animateTransition(_ transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, from fromView: UIView, to toView: UIView) {
    }
    
}
