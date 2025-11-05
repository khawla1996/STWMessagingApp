import UIKit
import CoreData

class ConversationsListViewController: UITableViewController, UISearchResultsUpdating {

    var conversations: [Conversation] = []
    var filtered: [Conversation] = []
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Conversations", comment: "")
        setupSearch()
        loadConversations()
    }

    func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    func loadConversations() {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        do {
            conversations = try CoreDataStack.shared.context.fetch(request)
            filtered = conversations
            tableView.reloadData()
        } catch {
            print("Error loading conversations: \(error)")
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty { filtered = conversations }
        else {
            filtered = conversations.filter { $0.contactName.lowercased().contains(text.lowercased()) }
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "convCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "convCell")
        let conv = filtered[indexPath.row]
        cell.textLabel?.text = conv.contactName
        if let lastMessage = (conv.messages as? Set<Message>)?.sorted(by: { $0.timestamp > $1.timestamp }).first {
            cell.detailTextLabel?.text = lastMessage.text
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConversationViewController()
        vc.conversation = filtered[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
