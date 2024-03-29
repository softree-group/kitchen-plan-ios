import Foundation

protocol MyRecipesModuleInput {
    var moduleOutput: MyRecipesModuleOutput? { get }
}

protocol MyRecipesModuleOutput: AnyObject {
}

protocol MyRecipesViewInput: BaseRecipesViewInput {
}

protocol MyRecipesViewOutput: BaseRecipesViewOutput {
    func didTapAdd()
    func didDelete(at idx: Int)
}

protocol MyRecipesInteractorInput: AnyObject {
    func loadMyRecipes() -> [RecipesViewModel]
    func addRecipe(with model: CreatedReceipt) -> RecipesViewModel
    func deleteRecipe(id: Int)
}

protocol MyRecipesInteractorOutput: AnyObject {
    func didLoad(recipes: [RecipesViewModel])
    func didReceive()
}

protocol MyRecipesRouterInput: AnyObject {
    func showCreateReceipt()
    func showReceipt(with model: RecipesViewModel)
}

protocol MyRecipesRouterOutput: AnyObject {
    func showReceipt(with model: RecipesViewModel)
}
