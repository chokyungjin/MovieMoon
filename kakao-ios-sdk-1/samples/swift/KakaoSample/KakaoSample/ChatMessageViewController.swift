/**
 * Copyright 2015-2018 Kakao Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit

class ChatMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    var chatContext: KOChatContext!
    var allChats: [KOChat] = []
    var filteredChats: [KOChat] = []
    var searchText: String?
    
    var requesting: Bool = false
    var selectedChat: KOChat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        chatContext = KOChatContext(chatFilters: .none, limit: 30, ordering: .ascending)
        requestChatList()
    }
    
    func updateViews() {
        filteredChats.removeAll()
        for chat in allChats {
            if (searchText ?? "").isEmpty  || chat.title.range(of: searchText!, options: NSString.CompareOptions.caseInsensitive) != nil {
                filteredChats.append(chat)
            }
        }
        tableView.reloadData()
    }
    
    func requestChatList() {
        if chatContext == nil {
            print("chatContext must be setup.")
            return
        }
        
        if requesting || !chatContext.hasMoreItems {
            return
        }
        
        requesting = true
        KOSessionTask.talkChatListTask(with: chatContext, completionHandler: { [weak self] (chats, error) -> Void in
            if let error = error as NSError? {
                print("Chats error=\(error)")
                switch error.code {
                case Int(KOErrorCancelled.rawValue):
                    _ = self?.navigationController?.popViewController(animated: true)
                    break
                default:
                    UIAlertController.showMessage(error.description)
                    break
                }
            } else if let chats = chats {
                if let totalCount = self?.chatContext.totalCount {
                    self?.title = "Chat (\(totalCount))"
                }
                self?.allChats.append(contentsOf: chats)
                self?.updateViews()
            }
            self?.requesting = false
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var normalCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if normalCell == nil {
            normalCell = ThumbnailImageViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        }
        
        let chat = filteredChats[(indexPath as NSIndexPath).row]
        
        normalCell?.textLabel?.text = chat.title
        normalCell?.detailTextLabel?.text = "Members : \(chat.memberCount!)"
        normalCell?.imageView?.image = UIImage(named: "PlaceHolder")
        if let url = chat.thumbnailURL, let imageUrl = URL(string: url) {
            normalCell?.imageView?.setImage(withUrl: imageUrl)
        }
        
        // load more
        let count = filteredChats.count
        if (indexPath as NSIndexPath).row > (count - count / 3) {
            requestChatList()
        }
        
        return normalCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedChat = filteredChats[(indexPath as NSIndexPath).row]
        
        UIAlertController.showAlert(title: "Send Message?", message: nil, actions: [
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil),
            UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                self.sendTemplateMessage()
            })
        ])
    }
    
    func sendTemplateMessage() {
        if selectedChat == nil {
            return
        }
        
        let chat: KOChat = selectedChat!
        selectedChat = nil
        
        chat.sendMessage(withTemplateId: MessageConstants.feedTemplateID, templateArgs: nil, completionHandler: { (error) -> Void in
            if let error = error as NSError? {
                UIAlertController.showMessage("message send failed:\(error)")
            } else {
                UIAlertController.showMessage("message send succeed.")
            }
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        updateViews()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = self.searchText
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = self.searchText
    }
}
