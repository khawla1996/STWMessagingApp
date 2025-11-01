
import SwiftUI
//
//  Contact.swift
//  STWMessagingApp
//
//  Created by khawla on 01/11/2025.
//

/// The ContactsView displays a list of the user's local contacts.
/// It allows searching by first or last name and navigating to a conversation view
/// when a contact is selected.
struct ContactsView: View {
    
    /// ViewModel responsible for providing and managing contact data.
    @ObservedObject var viewModel: ContactsViewModel
    
    /// The search text entered by the user in the search bar.
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            // The main list displaying all filtered contacts.
            List {
                // Loop through all contacts matching the search text.
                ForEach(viewModel.filteredContacts(searchText: searchText)) { contact in
                    
                    // Each contact is a navigation link leading to a ConversationView.
                    NavigationLink(destination: ConversationView(viewModel: ConversationViewModel(contact: contact))) {
                        HStack {
                            // Display the contact’s image if available.
                            if let image = contact.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                // Placeholder circle with initials if no image exists.
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                    .overlay(Text

