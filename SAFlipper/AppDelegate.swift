
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController = NavigationController()
    var navigationControllerAnimationController: CEReversibleAnimationController!
    var navigationControllerInteractionController: CEBaseInteractionController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let firstViewController = FirstViewController.initViewController()
        navigationController = NavigationController.initViewController(controller: firstViewController)
        navigationController.delegate = navigationController
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let cont = CEFlipAnimationController()
        navigationControllerAnimationController = cont
        
        
        return true
    }
    
    class func appDelegateShared() ->AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
}

