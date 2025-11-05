import UIKit

/// Lightweight message cell that supports text, image and POI-preview
public class MessageCell: UITableViewCell {
    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private let messageImageView = UIImageView()
    private let poiLabel = UILabel()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    private func setup() {
        bubbleView.layer.cornerRadius = 14
        bubbleView.clipsToBounds = true
        contentView.addSubview(bubbleView)

        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 15)
        bubbleView.addSubview(messageLabel)

        messageImageView.contentMode = .scaleAspectFill
        messageImageView.clipsToBounds = true
        bubbleView.addSubview(messageImageView)

        poiLabel.numberOfLines = 2
        poiLabel.font = .systemFont(ofSize: 13)
        poiLabel.textColor = .secondaryLabel
        bubbleView.addSubview(poiLabel)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        // simple layout: full width bubble with padding
        let padding: CGFloat = 12
        bubbleView.frame = CGRect(x: padding, y: 6, width: contentView.bounds.width - padding*2, height: contentView.bounds.height - 12)
        // Prioritize image > poi > text
        if messageImageView.image != nil {
            messageImageView.frame = bubbleView.bounds
            messageLabel.frame = .zero
            poiLabel.frame = .zero
        } else if poiLabel.text != nil && !(poiLabel.text!.isEmpty) {
            poiLabel.frame = bubbleView.bounds.insetBy(dx: 10, dy: 10)
            messageLabel.frame = .zero
            messageImageView.frame = .zero
        } else {
            messageLabel.frame = bubbleView.bounds.insetBy(dx: 10, dy: 10)
            messageImageView.frame = .zero
            poiLabel.frame = .zero
        }
    }

    /// Configure cell with a Core Data Message object
    public func configure(with message: Message) {
        // Reset views
        messageImageView.image = nil
        messageLabel.text = nil
        poiLabel.text = nil

        // Image
        if let data = message.imageData, let img = UIImage(data: data) {
            messageImageView.image = img
            bubbleView.backgroundColor = .clear
            return
        }

        // POI list preview
        if let poiData = message.poiData {
            // decode top-level POI names (safe decode)
            if let decoded = try? JSONDecoder().decode([POIItem].self, from: poiData) {
                let names = decoded.prefix(5).map { $0.name }
                poiLabel.text = names.joined(separator: "\\n")
                bubbleView.backgroundColor = UIColor.systemGray6
                return
            }
        }

        // plain text
        messageLabel.text = message.text
        bubbleView.backgroundColor = UIColor.systemGray6
    }
}
