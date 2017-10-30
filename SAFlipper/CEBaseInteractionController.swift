
import UIKit

enum CEInteractionOperation : Int {
    case CEInteractionOperationPop
    case CEInteractionOperationDismiss
    case CEInteractionOperationTab
}

class CEBaseInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false

    func wire(to viewController: UIViewController, for operation: CEInteractionOperation) throws {
        throw NSException(name: NSExceptionName.internalInconsistencyException, reason: "You must override \(NSStringFromSelector(#function)) in a subclass", userInfo: nil) as! Error
    }
    
}
