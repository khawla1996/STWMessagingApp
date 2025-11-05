//
//  STWMessagingApp
//
//  Created by khawla 
//

import UIKit
import CoreData

/// View controller responsible for displaying the list of conversations.
/// Includes search functionality and navigation to the selected conversation.
class ConversationsListViewController: UITableViewController, UISearchResultsUpdating {

var mConversations: [Conversation] = []
var mFiltered: [Conversation] = []
let searchController = UISearchController(searchResultsController: nil)

override func viewDidLoad() {
    super.viewDidLoad()
    title = NSLocalizedString("Conversations", comment: "")
    setupSearch()
    loadConversations()
}


// MARK: - Setup Search Controller

/// Configure the search controller and integrate it into the navigation bar.
func setupSearch() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
}


// MARK: - Load Conversations

/// Fetch all stored conversations from Core Data and reload the table view.

func loadConversations() {
    let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
    do {
        mConversations = try CoreDataStack.shared.context.fetch(request)
        mFiltered = mConversations
        tableView.reloadData()
    } catch {
        print("Error loading conversations: \(error)")
    }
}

func updateSearchResults(for searchController: UISearchController) {
    guard let theText = searchController.searchBar.text else { return }
    if theText.isEmpty { mFiltered = conversations }
    else {
        mFiltered = mConversations.filter { $0.contactName.lowercased().contains(theText.lowercased()) }
    }
    tableView.reloadData()
}

  // MARK: - TableView DataSource

/// Return the number of rows based on the filtered conversations.
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mFiltered.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "convCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "convCell")
    let conv = mFiltered[indexPath.row]
    cell.textLabel?.text = conv.contactName
            // Retrieve and display the latest message text if available

    if let lastMessage = (conv.messages as? Set<Message>)?.sorted(by: { $0.timestamp > $1.timestamp }).first {
        cell.detailTextLabel?.text = lastMessage.text
    }
    return cell
}

// MARK: - TableView Delegate

/// Handle the selection of a conversation and navigate to the conversation view.
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = ConversationViewController()
    vc.conversation = mFiltered[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
}
}
