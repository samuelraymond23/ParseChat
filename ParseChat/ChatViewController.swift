//
//  ChatViewController.swift
//  ParseChat
//
//  Created by student on 4/18/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var chatMessageField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    
    var parseMessages: [PFObject] = []
    var message: String!
    var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.separatorStyle = .none
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        // Auto size row height based on cell autolayout constraints
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 100
        messageTableView.rowHeight = 100
        
        refresh = UIRefreshControl()
        messageTableView.insertSubview(refresh, at: 0)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(toRefresh), userInfo: nil, repeats: true)
        
    }
    
    @objc func toRefresh() {
        fetchMessages()
        self.messageTableView.reloadData()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let chatMessage = PFObject(className: "Message")
        
        if let currentUser = PFUser.current() {
            chatMessage["user"] = currentUser
        }
        
        chatMessage["text"] = chatMessageField.text ?? ""
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.chatMessageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parseMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        // add saved messages to tableview ? cell.messageLabel
        let message = parseMessages[indexPath.row]
        cell.messageLabel.text = message["text"] as! String!
        
        if let user = message["user"] as? PFUser {
            // User found! update username label with username
            cell.userLabel.text = user.username
        } else {
            // No user found, set default username
            cell.userLabel.text = "Sam"
        }
        
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMessages() {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        
        query.findObjectsInBackground(){
            (messages: [PFObject]?, error: Error?) in
            if error == nil {
                if let messages = messages {
                    self.parseMessages = messages
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    @IBAction func toLogout(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "loginView") as? LoginViewController
        self.present(chatViewController!, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
