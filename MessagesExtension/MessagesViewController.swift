//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Tim Rayle on 9/23/16.
//  Copyright © 2016 Knoable. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        super.willBecomeActive(with: conversation)
        
        // Present the view controller appropriate for the conversation and presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        print("Received")
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        
        // Present the view controller appropriate for the conversation and presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        // Determine if this user is receiving a coin flip text or wants to send one.
        var controller: UIViewController
        
        // If coin information is in the message, this user needs to call heads or tails
        if let receivedCoinFlip = Coin(message: conversation.selectedMessage) {
            let callItController = (storyboard?.instantiateViewController(withIdentifier: CallItViewController.storyboardIdentifier) as? CallItViewController)!

            callItController.coin = receivedCoinFlip
            callItController.delegate = self
            controller = callItController
        }
        // Otherwise, create a new coin to flip
        else {
            let flipIt = Coin()
            let flipController = (storyboard?.instantiateViewController(withIdentifier: CoinFlipViewController.storyboardIdentifier) as? CoinFlipViewController)!
            
            flipController.coin = flipIt
            flipController.delegate = self
            controller = flipController
        }
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        // Embed the new controller.
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
    }
    
    fileprivate func composeMessage(with coin: Coin, caption: String, session: MSSession? = nil) -> MSMessage {
        
        // append the coin flip information to the message
        var components = URLComponents()
        components.queryItems = coin.queryItems
        
        // add an image and caption
        //TODO: add a flipping animation
        let layout = MSMessageTemplateLayout()
        layout.image = coin.renderSticker(opaque: true)
        layout.caption = caption
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }
}

// Process calls coming from the CoinFlipViewController
extension MessagesViewController: CoinFlipViewControllerDelegate {
    func buildCoinFlippedMessage(_ controller: CoinFlipViewController) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        guard let coin = controller.coin else { fatalError("Expected the controller to be displaying a coin") }
        
        let messageCaption = "You call it: Heads or Tails?"
        
        // Create a new message with the same session as any currently selected message.
        let message = composeMessage(with: coin, caption: messageCaption, session: conversation.selectedMessage?.session)
        
        // Add the message to the conversation.
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        
        dismiss()
    }
}

// Process calls from the CallItViewController
extension MessagesViewController: CallItViewControllerDelegate {
    func buildCalledItMessage(_ controller: CallItViewController) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        guard let coin = controller.coin else { fatalError("Expected the controller to be displaying a coin") }
        guard let messageIn = conversation.selectedMessage else { fatalError("Expected a selected coin flip message") }
        
        let localName = conversation.localParticipantIdentifier.uuidString
        let remoteName = conversation.remoteParticipantIdentifiers[0].uuidString
//        print("the local participant is: \(localName) remote is \(remoteName)")
        // Announce the winner
        let messageCaption = coin.calledIt ? "$\(localName) won" : "$\(remoteName) won"
//        let messageCaption = "$\(localName) me $\(remoteName) them $\(messageIn.senderParticipantIdentifier) sender"
        
        // Create a new message to send the flip results back to the sender.
        let message = composeMessage(with: coin, caption: messageCaption, session: conversation.selectedMessage?.session)
        
        // Add the message to the conversation.
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        dismiss()
    }
}


