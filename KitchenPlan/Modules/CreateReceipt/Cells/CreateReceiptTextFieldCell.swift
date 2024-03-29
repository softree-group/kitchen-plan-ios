import Foundation
import UIKit
import PinLayout

final class CreateReceiptTextFieldCell: InputCell {
    private let button = UIButton()
    private let textField = UITextField()
    private var section: Int?
    private var row: Int?
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
        textField.overrideUserInterfaceStyle = .light
        textField.delegate = self
        button.addTarget(self, action: #selector(didTapButton), for: .touchDown)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.imageView?.tintColor = .systemGreen
        
        [button, textField].forEach{
            contentView.addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    func layout() {
        button.pin
            .left(contentView.pin.safeArea + 10)
            .height(24)
            .sizeToFit(.height)
            .vCenter()
        
        textField.pin
            .after(of: button)
            .marginLeft(10)
            .vCenter()
            .height(24)
            .right()
    }
    
    func setMinusImage() {
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.imageView?.tintColor = .red
    }
    
    @objc func didTapButton() {
        guard let section = section, let row = row else {
            return
        }
        
        self.output?.didTapButton(section: section, row: row)
    }
    
    override func getData() -> String? {
        return textField.text
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)

        layout()
            
        return CGSize(width: contentView.frame.width, height: contentView.frame.maxY + 10)
    }

    func configure(output: CreateReceiptViewController, title: String, section: Int, row: Int) {
        self.output = output
        self.section = section
        self.row = row
        textField.placeholder = title
    }
}

extension CreateReceiptTextFieldCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let point = contentView.superview?.convert(contentView.frame, to: nil) else {
            return
        }
        
        output?.beginEnter(at: point.minY)
    }
}
