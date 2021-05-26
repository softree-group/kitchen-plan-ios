import Foundation
import UIKit

protocol CreateReceiptModuleInput {
	var moduleOutput: CreateReceiptModuleOutput? { get }
}

protocol CreateReceiptModuleOutput: AnyObject {
}

protocol CreateReceiptViewInput: AnyObject {
}

protocol CreateReceiptViewOutput: AnyObject {
}

protocol CreateReceiptInteractorInput: AnyObject {
}

protocol CreateReceiptInteractorOutput: AnyObject {
}

protocol CreateReceiptRouterInput: AnyObject {
}

protocol DataGetter: AnyObject {
    func getData() -> String?
}
