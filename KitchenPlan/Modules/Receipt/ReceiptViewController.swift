import UIKit
import PinLayout
import Kingfisher

final class ReceiptViewController: UIViewController {
	private let output: ReceiptViewOutput
    private let model: RecipesViewModel
    private let favoriteButton = UIButton()
    
    private let table = UITableView()
    
    init(output: ReceiptViewOutput, model: RecipesViewModel) {
        self.output = output
        self.model = model

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        table.backgroundColor = .white
        table.separatorStyle = .none
        
        let tableHeaderHeight = CGFloat(40)
        let tableWidth = self.table.bounds.size.width
        let tableFrame = CGRect(x: 0, y: 0, width: tableWidth , height: tableHeaderHeight)
        self.table.tableHeaderView = UIView(frame: tableFrame)
        table.contentInset = UIEdgeInsets(top: -tableHeaderHeight, left: 0, bottom: 0, right: 0)
        
        table.delegate = self
        table.dataSource = self
        
        favoriteButton.setImage(UIImage(systemName: output.isFavorite() ? "heart.fill" : "heart"), for: .normal)
        favoriteButton.contentVerticalAlignment = .fill
        favoriteButton.contentHorizontalAlignment = .fill
        favoriteButton.tintColor = .init(red: 250/255, green: 112/255, blue: 102/255, alpha: 1)
        favoriteButton.addTarget(self, action: #selector(didTapHeart), for: .touchUpInside)
        
        [table, favoriteButton].forEach {
            view.addSubview($0)
        }
        
        self.output.didLoadView()
    }
    
    @objc func didTapHeart() {
        favoriteButton.setImage(UIImage(systemName: output.isFavorite() ? "heart" : "heart.fill"), for: .normal)
        output.didTapHeart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        table.pin.all()
        favoriteButton.pin
            .height(32)
            .width(40)
            .top(10)
            .right(10)
    
    }
}

extension ReceiptViewController: ReceiptViewInput {
    func loadData(with model: Receipt) {
        table.reloadData()
    }
    
}

extension ReceiptViewController: UITableViewDelegate {
    
}

extension ReceiptViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = MainReceiptInfoCell()
            var type = "..."
            if let model = output.getModel() {
                type = model.type
            }
        
            cell.configure(with: model, type: type)
            return cell
        case 1:
            let cell = OrderedList()
            if let model = output.getModel() {
                cell.configure(title: "Ингредиенты", with: model.ingredients)
            } else {
                cell.configure(title: "Ингредиенты", with: [])
            }
            return cell
        case 2:
            let cell = OrderedList()
            if let model = output.getModel() {
                cell.configure(title: "Шаги", with: model.steps)
            } else {
                cell.configure(title: "Шаги", with: [])
            }
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
