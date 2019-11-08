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

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController: UISearchController! = UISearchController(searchResultsController: nil)

    var allFriends: [KOAppFriend] = []
    var filteredFriends: [KOAppFriend] = []
    
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        requestFriends(KOAppFriendContext(limit: 100, ordering: .ascending))
    }
    
    func updateViews() {
        filteredFriends.removeAll()
        for friend in allFriends {
            if (searchText ?? "").isEmpty || friend.nickname?.range(of: searchText!, options: NSString.CompareOptions.caseInsensitive) != nil {
                filteredFriends.append(friend)
            }
        }
        tableView.reloadData()
    }
    
    func requestFriends(_ friendContext: KOAppFriendContext) -> Void {
        
        // 친구 목록 조회
        
        KOSessionTask.appFriends(with: friendContext) { [weak self] (error, friends) in
            if let friends = friends {
                self?.allFriends.append(contentsOf: friends)
                if friendContext.hasMoreItems {
                    self?.requestFriends(friendContext)
                } else {
                    self?.updateViews()
                }
            } else if let error = error as NSError? {
                print(error)
                if error.code == KOErrorCancelled.rawValue {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    UIAlertController.showMessage(error.description)
                }
            }
        }
    }
    
    func requestMessageSend(template: KMTTemplate, receiverUuids: [String]) {
        
        // 기본 템플릿 메시지 보내기
        
        KOSessionTask.sendMessageToFriends(with: template, receiverUuids: receiverUuids) { (successfulReceiverUuids, failureInfo, error) in
            if let successfulReceiverUuids = successfulReceiverUuids {
                var message = "메시지 보내기 성공!\n\(successfulReceiverUuids)"
                if let failureInfo = failureInfo {
                    message += "\n부분 실패: \(failureInfo)"
                }
                UIAlertController.showMessage(message)
            } else if let error = error as NSError? {
                print(error)
                if error.code != KOErrorCancelled.rawValue {
                    UIAlertController.showMessage(error.description)
                }
            }
        }
    }
    
    func requestMessageSend(url: URL, receiverUuids: [String]) {
        
        // 스크랩 템플릿 메시지 보내기
        
        KOSessionTask.sendMessageToFriendsTask(with: url, receiverUuids: receiverUuids) { (successfulReceiverUuids, failureInfo, error) in
            if let successfulReceiverUuids = successfulReceiverUuids {
                var message = "메시지 보내기 성공!\n\(successfulReceiverUuids)"
                if let failureInfo = failureInfo {
                    message += "\n부분 실패: \(failureInfo)"
                }
                UIAlertController.showMessage(message)
            } else if let error = error as NSError? {
                print(error)
                if error.code != KOErrorCancelled.rawValue {
                    UIAlertController.showMessage(error.description)
                }
            }
        }
    }
    
    func requestMessageSend(templateId: String, receiverUuids: [String]) {
        
        // 커스텀 템플릿 메시지 보내기
        
        KOSessionTask.sendMessageToFriendsTask(withTemplateId: templateId, templateArgs: nil, receiverUuids: receiverUuids) { (successfulReceiverUuids, failureInfo, error) in
            if let successfulReceiverUuids = successfulReceiverUuids {
                var message = "메시지 보내기 성공!\n\(successfulReceiverUuids)"
                if let failureInfo = failureInfo {
                    message += "\n부분 실패: \(failureInfo)"
                }
                UIAlertController.showMessage(message)
            } else if let error = error as NSError? {
                print(error)
                if error.code != KOErrorCancelled.rawValue {
                    UIAlertController.showMessage(error.description)
                }
            }
        }
    }

    func defaultFeedTemplate() -> KMTFeedTemplate {
        return KMTFeedTemplate { (feedTemplateBuilder) in
            feedTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "베리베리 치즈 케익"
                contentBuilder.desc = "#케익 #딸기 #블루베리 #카페 #디저트 #달달함 #분위기 #삼평동"
                contentBuilder.imageURL = URL(string: "http://k.kakaocdn.net/dn/bDgfik/btqwQWk4CRU/P6wNJJiQ3Ko21KNE1TiLw1/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                    linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
                })
            })
            feedTemplateBuilder.social = KMTSocialObject(builderBlock: { (socialBuilder) in
                socialBuilder.likeCount = 286
                socialBuilder.commnentCount = 45
                socialBuilder.sharedCount = 845
            })
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "웹으로 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                    linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
                })
            }))
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "앱으로 열기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
                    linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
                })
            }))
        }
    }
    
    func defaultListTemplate() -> KMTListTemplate {
        return KMTListTemplate(builderBlock: { (listTemplateBuilder) in
            listTemplateBuilder.headerTitle = "WEEKLY MAGAZINE"
            listTemplateBuilder.headerLink = KMTLinkObject(builderBlock: { (linkBuilder) in
                linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
            })
            listTemplateBuilder.addContent(KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "오직 당신만을 위한 책을 만들어 드립니다."
                contentBuilder.desc = "브런치팀"
                contentBuilder.imageURL = URL(string: "http://k.kakaocdn.net/dn/j8Oiy/btqwRCGGjrl/9WxQofSJNnk6KzhbCiunD1/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                    linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
                })
            }))
            listTemplateBuilder.addContent(KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "우리 함께 책 읽어요. 가볍게 시작하는 독서"
                contentBuilder.desc = "도서"
                contentBuilder.imageURL = URL(string: "http://k.kakaocdn.net/dn/kIxII/btqwP7m6Rkb/PpnGXt72ToNhy9fgAvC5Kk/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                    linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
                })
            }))
            listTemplateBuilder.addContent(KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "아이와 함께하는 음식이야기 - 베이킹편"
                contentBuilder.desc = "음식"
                contentBuilder.imageURL = URL(string: "http://k.kakaocdn.net/dn/XlVQM/btqwOr7IFSG/uR2xkgzhH0S6TOFF9wkMRK/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                    linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
                })
            }))
            listTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "웹으로 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                    linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
                })
            }))
            listTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "앱으로 열기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
                    linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
                })
            }))
        })
    }
    
    func defaultCommerceTemplate() -> KMTCommerceTemplate {
        return KMTCommerceTemplate(builderBlock: { (commerceTemplateBuilder) in
            commerceTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "데일리 룩으로 좋은 화이트 셔츠"
                contentBuilder.desc = "White Shirt(1 Color)"
                contentBuilder.imageURL = URL(string: "http://k.kakaocdn.net/dn/JKZDK/btqwO690vVe/fThfikUTubQ3dA9PLYu0TK/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                    linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
                })
            })
            commerceTemplateBuilder.commerce = KMTCommerceObject(builderBlock: { (commerceBuilder) in
                commerceBuilder.regularPrice = 30000
                commerceBuilder.discountPrice = 21000
                commerceBuilder.discountRate = 30
            })
            commerceTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "구매하기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                    linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
                })
            }))
            commerceTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "공유하기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                    linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
                })
            }))
        })
    }

    func defaultLocationTemplate() -> KMTLocationTemplate {
        return KMTLocationTemplate(builderBlock: { (locationTemplateBuilder) in
            locationTemplateBuilder.addressTitle = "카카오 판교오피스 카페톡"
            locationTemplateBuilder.address = "경기 성남시 분당구 판교역로 235 에이치스퀘어 N동 8층"
            locationTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "신메뉴 출시, 초코 브라우니"
                contentBuilder.desc = "#브라우니 #초코 #카라멜 #아이스크림 #카페 #디저트 #달달함 #분위기 #삼평동"
                contentBuilder.imageURL = URL(string: "http://k.kakaocdn.net/dn/RWBKp/btqwRBA7BqR/fCZxTAWlQwU1kvZJaaleA0/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                    linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
                })
            })
            locationTemplateBuilder.social = KMTSocialObject(builderBlock: { (socialBuilder) in
                socialBuilder.likeCount = 286
                socialBuilder.commnentCount = 45
                socialBuilder.sharedCount = 845
            })
            locationTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "자세히 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")!
                    linkBuilder.webURL = URL(string: "https://developers.kakao.com")!
                })
            }))
        })
    }

    @IBAction func sendAction(_ sender: Any) {
        guard let indexPaths = self.tableView.indexPathsForSelectedRows, indexPaths.count > 0 else {
            return
        }
        
        var receiverUuids: [String] = []
        for indexPath in indexPaths {
            let friend = self.filteredFriends[indexPath.row]
            receiverUuids.append(friend.uuid)
        }
        
        UIAlertController.showAlert(title: "메시지 보내기", message: "대상 UUID:\n\(receiverUuids)", actions: [
            UIAlertAction(title: "기본 템플릿 (Feed)", style: .default, handler: { [weak self] (action) in
                guard let template = self?.defaultFeedTemplate() else { return }
                self?.requestMessageSend(template: template, receiverUuids: receiverUuids)
            }),
            UIAlertAction(title: "기본 템플릿 (List)", style: .default, handler: { [weak self] (action) in
                guard let template = self?.defaultListTemplate() else { return }
                self?.requestMessageSend(template: template, receiverUuids: receiverUuids)
            }),
            UIAlertAction(title: "기본 템플릿 (Commerce)", style: .default, handler: { [weak self] (action) in
                guard let template = self?.defaultCommerceTemplate() else { return }
                self?.requestMessageSend(template: template, receiverUuids: receiverUuids)
            }),
            UIAlertAction(title: "기본 템플릿 (Location)", style: .default, handler: { [weak self] (action) in
                guard let template = self?.defaultLocationTemplate()else { return }
                self?.requestMessageSend(template: template, receiverUuids: receiverUuids)
            }),
            UIAlertAction(title: "스크랩 템플릿", style: .default, handler: { [weak self] (action) in
                self?.requestMessageSend(url: URL(string: "https://developers.kakao.com")!, receiverUuids: receiverUuids)
            }),
            UIAlertAction(title: "커스텀 템플릿 (Feed)", style: .default, handler: { [weak self] (action) in
                self?.requestMessageSend(templateId: MessageConstants.feedTemplateID, receiverUuids: receiverUuids)
            }),
            UIAlertAction(title: "커스텀 템플릿 (List)", style: .default, handler: { [weak self] (action) in
                self?.requestMessageSend(templateId: MessageConstants.listTemplateID, receiverUuids: receiverUuids)
            }),
            UIAlertAction(title: "커스텀 템플릿 (Commerce)", style: .default, handler: { [weak self] (action) in
                self?.requestMessageSend(templateId: MessageConstants.commerceTemplateID, receiverUuids: receiverUuids)
            }),
            UIAlertAction(title: "취소", style: .cancel, handler: nil)])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var normalCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if normalCell == nil {
            normalCell = ThumbnailImageViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        
        let friend = filteredFriends[(indexPath as NSIndexPath).row]
        let nickname = friend.nickname ?? "<unknown>"
        
        normalCell?.textLabel?.text = nickname
        normalCell?.imageView?.image = UIImage(named: "PlaceHolder")
        if let url = friend.thumbnailImageURL, url.absoluteString.isEmpty == false {
            normalCell?.imageView?.setImage(withUrl: url)
        }
        
        return normalCell!
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
