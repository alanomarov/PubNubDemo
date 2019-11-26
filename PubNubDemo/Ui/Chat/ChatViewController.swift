//
//  ChatViewController.swift
//  PubNumDemo
//
//  Created by Alan Omarov on 17/11/2019.
//  Copyright © 2019 Alan Omarov. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

final class ChatViewController: MessagesViewController {

    var channel: Channel?
    
    let chatManager = ChatManager.shared
    
    let messageDateFormatter = DateFormatter()
    
    let defaultTextFont = UIFont.boldSystemFont(ofSize: 10)
    
    private static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Chat", bundle: nil)
    }
    
    static func instantiate(channel: Channel) -> UIViewController {
        guard let controller =
            ChatViewController.storyboard.instantiateInitialViewController() as?
            ChatViewController else {
            fatalError("View controller can't be instantiated")
        }
        
        controller.channel = channel
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        self.messageInputBar.delegate = self
        
        // Configure Message Date Formatter
        messageDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        messageDateFormatter.doesRelativeDateFormatting = false
        messageDateFormatter.dateFormat = "h:mm a"
        
        self.navigationItem.rightBarButtonItem?.action = #selector(showDetails(sender:))
        
        if #available(iOS 13.0, *) {
            messageInputBar.inputTextView.textColor = .black
            messageInputBar.inputTextView.placeholderLabel.textColor = .black
            //messageInputBar.backgroundView.backgroundColor = .systemBackground
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe for model updates.
        channel?.updateHandler = reloadData
        channel?.unreadMessages = 0
        
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    private func reloadData() {
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    @objc private func showDetails(sender: UIBarButtonItem) {
        let chatDetailsViewController = ChatDetailsViewController.instantiate()
        chatDetailsViewController.channel = channel
        self.navigationController?.pushViewController(chatDetailsViewController, animated: true)
    }
}

// Just a requirement of MessageKit. Not used.
let sender1 = User(senderId: "User A", displayName: "Steven")

extension ChatViewController: MessagesDataSource {

    func currentSender() -> SenderType {
        return sender1
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return channel!.getMessages().count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return channel!.getMessages()[indexPath.section]
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let message = channel!.getMessages()[indexPath.section]
        
        return attributedString(message.senderId,
                                with: defaultTextFont,
                                and: .gray)
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath,
                               in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let message = channel!.getMessages()[indexPath.section]
      
        return attributedString(messageDateFormatter.string(from: message.sentAt),
                              with: defaultTextFont,
                              and: .gray)
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath,
                                  in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
        
    func attributedString(_ text: String, with font: UIFont, and color: UIColor) -> NSAttributedString {
        let attributes = stringAttributes(with: font, and: color)

        return NSAttributedString(string: text, attributes: attributes)
    }

    func stringAttributes(with font: UIFont, and color: UIColor) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color]
    }
}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        for component in inputBar.inputTextView.components {
            if let message = component as? String {
                chatManager.sendMessage(channel: channel!.uuid, text: message)
            }
        }

        inputBar.inputTextView.text = String()
    }
}
