
import UIKit

class FirstViewController: UIViewController,UIViewControllerTransitioningDelegate {
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var btnnext: UIButton!
    
    var colorIndex: Int = 0
    private var imgArray = [Any]()
    private var panRecognizer: UIPanGestureRecognizer?
    private var isMoved : Bool = false;
    class func initViewController() -> FirstViewController{
        let controller = FirstViewController(nibName: "FirstViewController", bundle: nil)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self;
        setTransition()
        navigationController?.isNavigationBarHidden = false
        imgArray = [UIImage(named: "img1.jpeg")!, UIImage(named: "img2.jpg")!, UIImage(named: "img3.jpg")!]
        imgMain.image = imgArray[colorIndex] as? UIImage
        colorIndex = (colorIndex + 1) % imgArray.count
        gesRec()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isMoved = false;
    }
    
    func gesRec() {
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.move))
        view.removeGestureRecognizer(panRecognizer!);
        view.addGestureRecognizer(panRecognizer!)
    }
    
    func setTransition() {
        let transitionInstance = CEFlipAnimationController()
        AppDelegate.appDelegateShared().navigationControllerAnimationController = transitionInstance
    }
    
    @objc func move(_ sender: UIPanGestureRecognizer) {
        if !isMoved {
            isMoved = true;
            let vel: CGPoint = sender.velocity(in: view)
            if vel.x > 0 {
                print("Left")
                navigationController?.popViewController(animated: true)
            } else {
                print("Right")
                self.nextClicked(btnnext)
            }
        }
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        let controller = FirstViewController.initViewController()
        controller.transitioningDelegate = self
        controller.colorIndex = colorIndex;
        navigationController?.pushViewController(controller, animated: true)
    }
    
    deinit {
        colorIndex = colorIndex - 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

