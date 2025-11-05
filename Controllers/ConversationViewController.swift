import UIKit
import CoreData
import CoreLocation
import MapKit

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var conversation: Conversation?
    var contactName: String = ""
    var messages: [Message] = []

    let tableView = UITableView()
    let messageField = UITextField()
    let sendButton = UIButton(type: .system)
    let imageButton = UIButton(type: .contactAdd)
    let poiButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = contactName
        setupUI()
        fetchMessages()
    }

    func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 60)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "msgCell")
        view.addSubview(tableView)

        messageField.frame = CGRect(x: 10, y: view.frame.height - 55, width: view.frame.width - 130, height: 45)
        messageField.placeholder = NSLocalizedString("Type a message", comment: "")
        messageField.borderStyle = .roundedRect
        view.addSubview(messageField)

        sendButton.frame = CGRect(x: view.frame.width - 110, y: view.frame.height - 55, width: 45, height: 45)
        sendButton.setTitle("📩", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        view.addSubview(sendButton)

        imageButton.frame = CGRect(x: view.frame.width - 60, y: view.frame.height - 55, width: 45, height: 45)
        imageButton.setTitle("📷", for: .normal)
        imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        view.addSubview(imageButton)

        poiButton.frame = CGRect(x: view.frame.width - 160, y: view.frame.height - 55, width: 45, height: 45)
        poiButton.setTitle("📍", for: .normal)
        poiButton.addTarget(self, action: #selector(sendPOI), for: .touchUpInside)
        view.addSubview(poiButton)
    }

    func fetchMessages() {
        if let conv = conversation {
            if let msgs = conv.messages as? Set<Message> {
                messages = msgs.sorted(by: { $0.timestamp < $1.timestamp })
            }
        }
        tableView.reloadData()
    }

    @objc func sendMessage() {
        guard let text = messageField.text, !text.isEmpty else { return }

        let msg = Message(context: CoreDataStack.shared.context)
        msg.id = UUID()
        msg.text = text
        msg.timestamp = Date()
        msg.isSent = true
        msg.conversation = conversation
        CoreDataStack.shared.saveContext()

        messages.append(msg)
        messageField.text = ""
        tableView.reloadData()
    }

    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage,
           let data = image.pngData() {
            let msg = Message(context: CoreDataStack.shared.context)
            msg.id = UUID()
            msg.imageData = data
            msg.timestamp = Date()
            msg.isSent = true
            msg.conversation = conversation
            CoreDataStack.shared.saveContext()
            messages.append(msg)
            tableView.reloadData()
        }
    }

    @objc func sendPOI() {
        let vc = POIListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! MessageCell
        let msg = messages[indexPath.row]
        cell.configure(with: msg)
        return cell
    }
}
