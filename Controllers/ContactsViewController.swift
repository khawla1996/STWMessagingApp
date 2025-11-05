import UIKit
import Contacts

class ContactsViewController: UITableViewController, UISearchResultsUpdating {

    var contacts: [CNContact] = []
    var filtered: [CNContact] = []
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Contacts", comment: "")
        setupSearch()
        fetchContacts()
    }

    func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    func fetchContacts() {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        try? store.enumerateContacts(with: request) { (contact, _) in
            self.contacts.append(contact)
        }
        filtered = contacts
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty { filtered = contacts }
        else {
            filtered = contacts.filter { c in
                c.givenName.lowercased().contains(text.lowercased()) ||
                c.familyName.lowercased().contains(text.lowercased())
            }
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let c = filtered[indexPath.row]
        cell.textLabel?.text = "\(c.givenName) \(c.familyName)"
        if let phone = c.phoneNumbers.first?.value.stringValue {
            cell.detailTextLabel?.text = phone
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = filtered[indexPath.row]
        let vc = ConversationViewController()
        vc.contactName = "\(contact.givenName) \(contact.familyName)"
        navigationController?.pushViewController(vc, animated: true)
    }
}
