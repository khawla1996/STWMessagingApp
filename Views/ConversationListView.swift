import SwiftUI
//
//  Contact.swift
//  STWMessagingApp
//
//  Created by khawla on 02/11/2025.
//

/// Displays the list of all existing conversations.
/// Allows the user to select a conversation and open it.
struct ConversationListView: View {
    @ObservedObject var viewModel: ConversationListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.conversations) { conversation in
                    NavigationLink(destination: ConversationView(viewModel: ConversationViewModel(contact: conversation.contact))) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(conversation.contact.firstName + " " + conversation.contact.lastName)
                                .font(.headline)
                            if let lastMessage = conversation.messages.last {
                                Text(lastMessage.text ?? "[Image]")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Conversations")
        }
    }
}

#Preview {
    ConversationListView(viewModel: ConversationListViewModel())
}
