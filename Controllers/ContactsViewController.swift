

//
//  STWMessagingApp
//
//  Created by khawla 
//

import UIKit
import Contacts


/// Displays the list of local contacts stored on the user's device.
/// Allows searching by first or last name and navigating to a chat (ConversationViewController) with a selected contact.

class ContactsViewController: UITableViewController, UISearchResultsUpdating {

var mContacts: [CNContact] = []
var mFilteredContact: [CNContact] = []
let searchController = UISearchController(searchResultsController: nil)

override func viewDidLoad() {
    super.viewDidLoad()
    theTitle = NSLocalizedString("Contacts", comment: "")
    setupSearch()
    fetchContacts()
}

func setupSearch() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
}

 // MARK: - Fetch Contacts
/// Retrieves all contacts from the user’s device using CNContactStore
func fetchContacts() {
    let theStore = CNContactStore()
    let theKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
    let theRequest = CNContactFetchRequest(keysToFetch: theKeys as [CNKeyDescriptor])
     // Try enumerating all contacts and append them to our list
    try? theStore.enumerateContacts(with: theRequest) { (contact, _) in
        self.theContacts.append(contact)
    }

  // Initialize filtered array
    mFilteredContact = contacts
    tableView.reloadData()
}

func updateSearchResults(for searchController: UISearchController) {
    guard let theText = searchController.searchBar.text else { return }
    if theText.isEmpty {
        // If the search text is empty, display all contacts
        mFilteredContact = mContacts }
    else {
         // Filter contacts by first name or last name
        mFilteredContact = mContacts.filter { c in
            c.givenName.lowercased().contains(text.lowercased()) ||
            c.familyName.lowercased().contains(text.lowercased())
        }
    }
    tableView.reloadData()
}

// MARK: - Table View Data Source
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mFilteredContact.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    let c = mFilteredContact[indexPath.row]
    cell.textLabel?.text = "\(c.givenName) \(c.familyName)"
    if let theContactPhone = c.phoneNumbers.first?.value.stringValue {
        cell.detailTextLabel?.text = theContactPhone
    }
    return cell
}

 // MARK: - Table View Delegate
/// When the user selects a contact, open a new conversation screen

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contact = mFilteredContact[indexPath.row]
    let vc = ConversationViewController()
    vc.contactName = "\(contact.givenName) \(contact.familyName)"
    
    /// Navigate to the conversation view
    navigationController?.pushViewController(vc, animated: true)
}
}
