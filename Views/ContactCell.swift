import UIKit
import Contacts

public class ContactCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let phoneLabel = UILabel()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        phoneLabel.font = .systemFont(ofSize: 13)
        phoneLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [nameLabel, phoneLabel])
        stack.axis = .vertical
        stack.spacing = 2
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    public func configure(with contact: CNContact) {
        nameLabel.text = "\(contact.givenName) \(contact.familyName)"
        phoneLabel.text = contact.phoneNumbers.first?.value.stringValue ?? ""
    }
}
