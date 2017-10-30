
import UIKit

class NavigationController: UINavigationController, UINavigationControllerDelegate {

    
    class func initViewController(controller:UIViewController) -> NavigationController{
        let navController = NavigationController(rootViewController: controller)
        return navController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        wirePopInteractionController(to: viewController)
    }
    
    func wirePopInteractionController(to viewController: UIViewController) {
        // when a push occurs, wire the interaction controller to the to- view controller
        if (AppDelegate.appDelegateShared().navigationControllerInteractionController != nil) {
            return
        }
        do {
            try AppDelegate.appDelegateShared().navigationControllerInteractionController?.wire(to: viewController, for: CEInteractionOperation.CEInteractionOperationPop)
        } catch {
            print(error)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (AppDelegate.appDelegateShared().navigationControllerAnimationController != nil) {
            AppDelegate.appDelegateShared().navigationControllerAnimationController.reverse = operation == .pop
        }
        return AppDelegate.appDelegateShared().navigationControllerAnimationController!
    }
    
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (AppDelegate.appDelegateShared().navigationControllerInteractionController != nil) && (AppDelegate.appDelegateShared().navigationControllerInteractionController?.interactionInProgress)! ? AppDelegate.appDelegateShared().navigationControllerInteractionController : nil
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 }
