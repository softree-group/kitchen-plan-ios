import Foundation

protocol ProfileModuleInput {
	var moduleOutput: ProfileModuleOutput? { get }
}

protocol ProfileModuleOutput: AnyObject {
}

protocol ProfileViewInput: AnyObject {
}

protocol ProfileViewOutput: AnyObject {
}

protocol ProfileInteractorInput: AnyObject {
}

protocol ProfileInteractorOutput: AnyObject {
}

protocol ProfileRouterInput: AnyObject {
}
