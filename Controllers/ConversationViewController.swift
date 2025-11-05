//
//  STWMessagingApp
//
//  Created by khawla 
//

import UIKit
import CoreData
import CoreLocation
import MapKit

/// View controller that handles a single conversation screen.
/// Allows sending text messages, images, and points of interest (POI).

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

 // MARK: - Properties
var mConversation: Conversation?
var mContactName: String = ""
var mMessages: [Message] = []

let mTableView = UITableView()
let mMessageField = UITextField()
let mSendButton = UIButton(type: .system)
let mImageButton = UIButton(type: .contactAdd)
let mPoiButton = UIButton(type: .system)

override func viewDidLoad() {
    super.viewDidLoad()
    theTitle = mContactName
    setupUI()
    fetchMessages()
}


// MARK: - Setup UI

/// Configure layout: message list, input field, and buttons.
func setupUI() {
    view.backgroundColor = .systemBackground
    mTableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 60)
    mTableView.dataSource = self
    mTableView.delegate = self
    mTableView.register(MessageCell.self, forCellReuseIdentifier: "msgCell")
    view.addSubview(mTableView)

    mMessageField.frame = CGRect(x: 10, y: view.frame.height - 55, width: view.frame.width - 130, height: 45)
    mMessageField.placeholder = NSLocalizedString("Type a message", comment: "")
    mMessageField.borderStyle = .roundedRect
    view.addSubview(mMessageField)

    mSendButton.frame = CGRect(x: view.frame.width - 110, y: view.frame.height - 55, width: 45, height: 45)
    mSendButton.setTitle("", for: .normal)
    mSendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    view.addSubview(mSendButton)

    mImageButton.frame = CGRect(x: view.frame.width - 60, y: view.frame.height - 55, width: 45, height: 45)
    mImageButton.setTitle("", for: .normal)
    mImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
    view.addSubview(mImageButton)

    mPoiButton.frame = CGRect(x: view.frame.width - 160, y: view.frame.height - 55, width: 45, height: 45)
    mPoiButton.setTitle("", for: .normal)
    mPoiButton.addTarget(self, action: #selector(sendPOI), for: .touchUpInside)
    view.addSubview(mPoiButton)
}

  // MARK: - Fetch Messages

/// Load all messages for the current conversation from Core Data.
func fetchMessages() {
    if let theConversation = conversation {
        if let msgs = theConversation.messages as? Set<Message> {
            mMessages = msgs.sorted(by: { $0.timestamp < $1.timestamp })
        }
    }
    tableView.reloadData()
}

 // MARK: - Send Text Message

/// Create and save a text message in Core Data.
@objc func sendMessage() {
    guard let text = messageField.text, !text.isEmpty else { return }

    let msg = Message(context: CoreDataStack.shared.context)
    msg.id = UUID()
    msg.text = text
    msg.timestamp = Date()
    msg.isSent = true
    msg.conversation = conversation
    CoreDataStack.shared.saveContext()

    mMessages.append(msg)
    messageField.text = ""
    tableView.reloadData()
}

// MARK: - Send Image Message

/// Open the image picker to select an image from the gallery.
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
        mMessages.append(msg)
        tableView.reloadData()
    }
}

 // MARK: - Send POI (Points of Interest)

/// Open the POI list screen to share nearby locations.
@objc func sendPOI() {
    let vc = POIListViewController()
    navigationController?.pushViewController(vc, animated: true)
}

// MARK: - TableView DataSource & Delegate

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mMessages.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! MessageCell
    let msg = mMessages[indexPath.row]
    cell.configure(with: msg)
    return cell
}
}
