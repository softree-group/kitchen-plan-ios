import Foundation
import UIKit
import PinLayout

final class CreateReceiptStepCell: UITableViewCell {
    private let plus = UIButton()
    private let stepName = UITextField()
    weak var output: CreateReceiptViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
           
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectionStyle = .none
        
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        backgroundColor = .white
        stepName.placeholder = "Шаг"
        
        plus.addTarget(self, action: #selector(didTapPlusButton), for: .touchDown)
        plus.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        
        [plus, stepName].forEach{
            contentView.addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    func layout() {
        plus.pin
            .left()
            .height(24)
            .sizeToFit(.height)
            .vCenter()
        
        stepName.pin
            .after(of: plus)
            .vCenter()
            .height(24)
            .right()
    }
    
    func configure(output: CreateReceiptViewController) {
        self.output = output
    }
    
    @objc func didTapPlusButton() {
        self.output?.didTapAddStep()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)

        layout()
            
        return CGSize(width: contentView.frame.width, height: contentView.frame.maxY + 10)
    }
}
