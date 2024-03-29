import Foundation

enum NetworkError: Error {
    case unexpected
}

protocol RecipesManagerDescription: AnyObject {
    func loadRecipes(since: Int,
                     limit: Int,
                     title: String?,
                     type: String?,
                     ingredients: [Int],
                     recipes: [Int],
                     completion: @escaping (Result<[ReceiptInfoResponse], Error>) -> Void)
    func loadReceipt(id: Int, completion: @escaping (Result<Receipt, Error>) -> Void)
}

final class RecipesManager {
    static let shared: RecipesManagerDescription = RecipesManager()
}

extension RecipesManager: RecipesManagerDescription {
    func loadReceipt(id: Int, completion: @escaping (Result<Receipt, Error>) -> Void) {
        guard let url = URL(string: backHost + "/recipes/" + String(id)) else {
            completion(.failure(NetworkError.unexpected))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.unexpected))
                return
            }
            
            let json = JSONDecoder()
            
            do {
                let result = try json.decode(Receipt.self, from: data)
                completion(.success(result))
            } catch let error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func loadRecipes(since: Int,
                     limit: Int,
                     title: String? = nil,
                     type: String? = nil,
                     ingredients: [Int],
                     recipes: [Int],
                     completion: @escaping (Result<[ReceiptInfoResponse], Error>) -> Void) {
        
        guard let url = URL(string: backHost + genPath(since: since,
                                                       limit: limit,
                                                       title: title,
                                                       type: type,
                                                       ingredients: ingredients,
                                                       recipes: recipes)) else {
            completion(.failure(NetworkError.unexpected))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.unexpected))
                return
            }
            
            let json = JSONDecoder()
            
            do {
                let result = try json.decode([ReceiptInfoResponse].self, from: data)
                completion(.success(result))
            } catch let error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func genPath(since: Int, limit: Int, title: String?, type: String?, ingredients: [Int], recipes: [Int]) -> String {
        var path = "/recipes?since=\(since)&limit=\(limit)"
        if let unwrappedTitle = title {
            if unwrappedTitle != "" {
                path += "&title=\(unwrappedTitle)"
            }
        }
        if let unwrappedType = type {
            path += "&type=\(unwrappedType.uppercased())"
        }
        if ingredients.count > 0 {
            path += genMultiQueryArgs(ids: ingredients, title: "ingredients")
        }
        if recipes.count > 0 {
            path += genMultiQueryArgs(ids: recipes, title: "id")
        }
        return path.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? path
    }
    
    func genMultiQueryArgs(ids: [Int], title: String) -> String {
        return ids.reduce("") { prev, curr in
            "\(prev)&\(title)=\(curr)"
        }
    }
}
