import Foundation

final class ProfilePresenter {
	weak var view: ProfileViewInput?
    weak var moduleOutput: ProfileModuleOutput?

	private let router: ProfileRouterInput
	private let interactor: ProfileInteractorInput

    init(router: ProfileRouterInput, interactor: ProfileInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension ProfilePresenter: ProfileModuleInput {
}

extension ProfilePresenter: ProfileViewOutput {
    func didSelectMyRecipes() {
        router.showMyRecipes()
    }
    
    func didSelectFavorites() {
        router.showFavorites()
    }
}

extension ProfilePresenter: ProfileInteractorOutput {
}
