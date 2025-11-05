import UIKit

public class ConversationCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    public func configure(with conversation: Conversation) {
        titleLabel.text = conversation.contactName
        // show preview from last message if exist
        if let msgs = conversation.messages as? Set<Message>, let last = msgs.sorted(by: { ($0.timestamp ?? Date()) > ($1.timestamp ?? Date()) }).first {
            if let _ = last.imageData { subtitleLabel.text = "[Image]" }
            else if last.text != nil { subtitleLabel.text = last.text }
            else if last.poiQuery != nil { subtitleLabel.text = "[POIs] \\(last.poiQuery ?? \"\")" }
            else { subtitleLabel.text = "" }
        } else {
            subtitleLabel.text = ""
        }
    }
}

