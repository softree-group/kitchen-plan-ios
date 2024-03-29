import UIKit
import PinLayout

final class IngredientsViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical

        return UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    }()
    private let output: IngredientsViewOutput
    private var trashButton: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(didTapTrash))
    }
    private var leftButtons: [UIBarButtonItem] {
        [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDelete)),
         UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelDelete))]
    }

    init(output: IngredientsViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1/3)),
            subitem: item,
            count: 3)

        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let bar = navigationController?.navigationBar {
            overrideNavigateBar(bar)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapAdd)
        )
        
        navigationItem.leftBarButtonItem = trashButton
        
        view.backgroundColor = .white

        configureCollectionView()

        view.addSubview(collectionView)
        output.didLoadView()
    }
    
    @objc func didTapTrash() {
        collectionView.isEditing = true
        navigationItem.setLeftBarButtonItems(leftButtons, animated: true)
        collectionView.reloadData()
    }
    
    @objc func doneDelete() {
        let itemsToDelete = collectionView.indexPathsForSelectedItems ?? []
        output.didDelete(for: itemsToDelete.map {$0.item})
        collectionView.deleteItems(at: itemsToDelete)
        if let cells = collectionView.visibleCells as? [IngredientsViewCell] {
            cells.forEach { cell in
                cell.resetCheckbox()
            }
        }

        cancelDelete()
    }
    
    @objc func cancelDelete() {
        collectionView.isEditing = false
        navigationItem.setLeftBarButtonItems([], animated: true)
        navigationItem.setLeftBarButton(trashButton, animated: true)
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(IngredientsViewCell.self, forCellWithReuseIdentifier: IngredientsViewCell.indetifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.allowsMultipleSelectionDuringEditing = true
    }
    
    @objc func didTapAdd() {
        output.didTapAdd()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.pin.all()
    }
}

extension IngredientsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, IngredientsViewInput {
    func reloadData() {
        collectionView.reloadData()
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.count()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientsViewCell.indetifier, for: indexPath) as? IngredientsViewCell else {
            return .init()
        }
        
        cell.configure(with: output.item(idx: indexPath.item), isEditing: collectionView.isEditing)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - 2
        let sideLength = availableWidth / 3

        return CGSize(width: sideLength, height: sideLength)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isEditing  {
            return
        }
        let alert = UIAlertController(title: output.item(idx: indexPath.item).title, message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: {action in
        }))
        alert.addAction(UIAlertAction(title: "Удалить", style: .default, handler: { [weak self] action in
            if let id = self?.output.item(idx: indexPath.item).id {
                self?.output.didDelete(for: id)
            }
        }))

        present(alert, animated: true, completion: nil)
    }
}
