//
//  FormTableViewCell.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/19.
//

import UIKit

// By adopting the FormTableViewCellDelegate protocol in your view controller, you can respond to text field changes within the cells. When a user types into a text field and presses "Return," the text field's delegate (the cell) notifies the delegate (the view controller) through the didUpdateField method. The view controller can then update its data or perform any necessary actions based on the changed value.
protocol FormTableViewCellDelegate: AnyObject {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel)
}

class FormTableViewCell: UITableViewCell, UITextFieldDelegate {
    // define a constant value that's shared across all instances of the type - FormTableViewCell.indentifier
    static let identifier = "FormTableViewCell"
    
    private var model: EditProfileFormModel?
    
    public weak var delegate: FormTableViewCellDelegate?
    
    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let field: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(field)
        field.delegate = self
        selectionStyle = .none
        
    }
    
    public func configure(with model: EditProfileFormModel) {
        self.model = model
        formLabel.text = model.label
        field.placeholder = model.placeholder
        field.text = model.value
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        formLabel.text = nil
        field.placeholder = nil
        field.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Assign frames
        formLabel.frame = CGRect(
            x: 5,
            y: 0,
            width: contentView.width/3,
            height: contentView.height)
        
        field.frame = CGRect(
            x: formLabel.right + 5,
            y: 0,
            width: contentView.width-10-formLabel.width,
            height: contentView.height)
    }
    
    // MARK: - Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        delegate?.formTableViewCell(self, didUpdateField: textField.text)
        model?.value = textField.text
        guard let model = model else {
            return true
        }
        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder()
        return true
    }
    
}
