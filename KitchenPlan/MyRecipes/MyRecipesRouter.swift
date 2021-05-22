import UIKit

final class MyRecipesRouter {
    weak var sourceViewController: UIViewController?
}

extension MyRecipesRouter: MyRecipesRouterInput {
    func showCreateReceipt() {
        let container = CreateReceiptContainer.assemble(with: nil)
        
        sourceViewController?.present(container.viewController, animated: true, completion: nil)
    }
}