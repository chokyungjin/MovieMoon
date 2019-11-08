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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var headers = ["KakaoLink", "Image Storage", "Etc"]
    fileprivate var menuItems = [[["Send Default", "(Feed Template)", "SendFeed"],
                                  ["Send Default", "(List Template)", "SendList"],
                                  ["Send Default", "(Location Template)", "SendLocation"],
                                  ["Send Default", "(Commerce Template)", "SendCommerce"],
                                  ["Send Scrap", "", "SendScrap"],
                                  ["Send Custom", "", "SendCustom"],],
                                 [["Upload Image", "", "Upload"],
                                  ["Scrap Image", "", "Upload"],],
                                 [["Story Posting", "", "StoryPosting"],
                                  ["Share File", "(UIDocumentInteractionController)", "ShareFile"],],]
    
    fileprivate var documentController: UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var normalCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if normalCell == nil {
            normalCell = IconTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        }
        
        let menuItem = menuItems[indexPath.section][indexPath.row]
        normalCell?.textLabel?.text = menuItem[0]
        normalCell?.detailTextLabel?.text = menuItem[1]
        normalCell?.imageView?.image = UIImage(named: menuItem[2])
        
        return normalCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                sendLinkFeed()
            case 1:
                sendLinkList()
            case 2:
                sendLinkLocation()
            case 3:
                sendLinkCommerce()
            case 4:
                sendLinkScrap()
            case 5:
                sendLinkCustom()
            default:
                fatalError("no menu items.")
            }
        case 1:
            switch indexPath.row {
            case 0:
                uploadLocalImage()
            case 1:
                scrapRemoteImage()
            default:
                fatalError("no menu items.")
            }
        case 2:
            switch indexPath.row {
            case 0:
                postStory()
            case 1:
                showChooseSharingFile()
            default:
                fatalError("no menu items.")
            }
        default:
            fatalError("no menu items.")
        }
    }
    
    func sendLinkFeed() -> Void {
        
        // Feed 타입 템플릿 오브젝트 생성
        let template = KMTFeedTemplate { (feedTemplateBuilder) in
            
            // 컨텐츠
            feedTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "딸기 치즈 케익"
                contentBuilder.desc = "#케익 #딸기 #삼평동 #까페 #분위기 #소개팅"
                contentBuilder.imageURL = URL(string: "http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            })
            
            // 소셜
            feedTemplateBuilder.social = KMTSocialObject(builderBlock: { (socialBuilder) in
                socialBuilder.likeCount = 286
                socialBuilder.commnentCount = 45
                socialBuilder.sharedCount = 845
            })
            
            // 버튼
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "웹으로 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            }))
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "앱으로 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
                    linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
                })
            }))
        }
        
        // 서버에서 콜백으로 받을 정보
        let serverCallbackArgs = ["user_id": "abcd",
                                  "product_id": "1234"]

        // 카카오링크 실행
        KLKTalkLinkCenter.shared().sendDefault(with: template, serverCallbackArgs: serverCallbackArgs, success: { (warningMsg, argumentMsg) in
            
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")
            
        }, failure: { (error) in
            
            // 실패
            UIAlertController.showMessage(error.localizedDescription)
            print("error \(error)")
            
        })
    }
    
    func sendLinkList() -> Void {
        
        // List 타입 템플릿 오브젝트 생성
        let template = KMTListTemplate { (listTemplateBuilder) in
            
            // 헤더 타이틀 및 링크
            listTemplateBuilder.headerTitle = "WEEKLY MAGAZINE"
            listTemplateBuilder.headerLink = KMTLinkObject(builderBlock: { (linkBuilder) in
                linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
            })
            
            // 컨텐츠 목록
            listTemplateBuilder.addContent(KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "취미의 특징, 탁구"
                contentBuilder.desc = "스포츠"
                contentBuilder.imageURL = URL(string: "http://mud-kage.kakao.co.kr/dn/bDPMIb/btqgeoTRQvd/49BuF1gNo6UXkdbKecx600/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            }))
            listTemplateBuilder.addContent(KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "크림으로 이해하는 커피이야기"
                contentBuilder.desc = "음식"
                contentBuilder.imageURL = URL(string: "http://mud-kage.kakao.co.kr/dn/QPeNt/btqgeSfSsCR/0QJIRuWTtkg4cYc57n8H80/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            }))
            listTemplateBuilder.addContent(KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "감성이 가득한 분위기"
                contentBuilder.desc = "사진"
                contentBuilder.imageURL = URL(string: "http://mud-kage.kakao.co.kr/dn/c7MBX4/btqgeRgWhBy/ZMLnndJFAqyUAnqu4sQHS0/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            }))
            
            // 버튼
            listTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "웹으로 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            }))
            listTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "앱으로 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
                    linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
                })
            }))
        }
        
        // 서버에서 콜백으로 받을 정보
        let serverCallbackArgs = ["user_id": "abcd",
                                  "product_id": "1234"]
        
        // 카카오링크 실행
        KLKTalkLinkCenter.shared().sendDefault(with: template, serverCallbackArgs: serverCallbackArgs, success: { (warningMsg, argumentMsg) in
            
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")

        }, failure: { (error) in
            
            // 실패
            UIAlertController.showMessage(error.localizedDescription)
            print("error \(error)")
            
        })
    }
    
    func sendLinkLocation() -> Void {
        
        // Location 타입 템플릿 오브젝트 생성
        let template = KMTLocationTemplate { (locationTemplateBuilder) in
            
            // 주소
            locationTemplateBuilder.address = "경기 성남시 분당구 판교역로 235 에이치스퀘어 N동 8층"
            locationTemplateBuilder.addressTitle = "카카오 판교오피스 카페톡"
            
            // 컨텐츠
            locationTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "신메뉴 출시❤️ 체리블라썸라떼"
                contentBuilder.desc = "이번 주는 체리블라썸라떼 1+1"
                contentBuilder.imageURL = URL(string: "http://mud-kage.kakao.co.kr/dn/bSbH9w/btqgegaEDfW/vD9KKV0hEintg6bZT4v4WK/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            })
            
            // 소셜
            locationTemplateBuilder.social = KMTSocialObject(builderBlock: { (socialBuilder) in
                socialBuilder.likeCount = 286
                socialBuilder.commnentCount = 45
                socialBuilder.sharedCount = 845
            })
        }
        
        // 서버에서 콜백으로 받을 정보
        let serverCallbackArgs = ["user_id": "abcd",
                                  "product_id": "1234"]
        
        // 카카오링크 실행
        KLKTalkLinkCenter.shared().sendDefault(with: template, serverCallbackArgs: serverCallbackArgs, success: { (warningMsg, argumentMsg) in
            
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")

        }, failure: { (error) in
            
            // 실패
            UIAlertController.showMessage(error.localizedDescription)
            print("error \(error)")
            
        })
    }
    
    func sendLinkCommerce() -> Void {
        
        // Commerce 타입 템플릿 오브젝트 생성
        let template = KMTCommerceTemplate { (commerceTemplateBuilder) in
            
            // 컨텐츠
            commerceTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "Ivory long dress (4 Color)"
                contentBuilder.imageURL = URL(string: "http://mud-kage.kakao.co.kr/dn/RY8ZN/btqgOGzITp3/uCM1x2xu7GNfr7NS9QvEs0/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            })
            
            // 가격
            commerceTemplateBuilder.commerce = KMTCommerceObject(builderBlock: { (commerceBuilder) in
                commerceBuilder.regularPrice = 208800
                commerceBuilder.discountPrice = 146160
                commerceBuilder.discountRate = 30
            })
            
            
            // 버튼
            commerceTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "구매하기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            }))
            commerceTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "공유하기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
                    linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
                })
            }))
        }
        
        // 서버에서 콜백으로 받을 정보
        let serverCallbackArgs = ["user_id": "abcd",
                                  "product_id": "1234"]
        
        // 카카오링크 실행
        KLKTalkLinkCenter.shared().sendDefault(with: template, serverCallbackArgs: serverCallbackArgs, success: { (warningMsg, argumentMsg) in
            
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")

        }, failure: { (error) in
            
            // 실패
            UIAlertController.showMessage(error.localizedDescription)
            print("error \(error)")
            
        })
    }
    
    func sendLinkScrap() -> Void {
        
        // 스크랩할 웹페이지 URL
        let url = URL(string: "https://store.kakaofriends.com/")!
        
        // 카카오링크 실행
        KLKTalkLinkCenter.shared().sendScrap(with: url, success: { (warningMsg, argumentMsg) in
            
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")

        }, failure: { (error) in
            
            // 실패
            UIAlertController.showMessage(error.localizedDescription)
            print("error \(error)")
            
        })
    }
    
    func sendLinkCustom() -> Void {
        
        // 템플릿 ID
        let templateId = MessageTemplateConstants.customTemplateID
        // 템플릿 Arguments
        let templateArgs = ["title": "제목 영역입니다.",
                            "description": "설명 영역입니다."]
        // 서버에서 콜백으로 받을 정보
        let serverCallbackArgs = ["user_id": "abcd",
                                  "product_id": "1234"]
        
        KLKTalkLinkCenter.shared().sendCustom(withTemplateId: templateId, templateArgs: templateArgs, serverCallbackArgs: serverCallbackArgs, success: { (warningMsg, argumentMsg) in
            
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")

        }, failure: { (error) in
            
            // 실패
            UIAlertController.showMessage(error.localizedDescription)
            print("error \(error)")
            
        })
    }
    
    func uploadLocalImage() -> Void {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // 업로드할 이미지
        let sourceImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        KLKImageStorage.shared().upload(with: sourceImage, success: { (original) in
            
            // 업로드 성공
            UIAlertController.showAlert(title: "", message: "업로드 성공\n\(original.url)", actions: [
                UIAlertAction(title: "삭제", style: .default, handler: { (alertAction) in
                    
                    // 업로드된 이미지 삭제
                    KLKImageStorage.shared().delete(withImageURL: original.url, success: {
                        // 삭제 성공
                        UIAlertController.showMessage("삭제 성공")
                    }, failure: { (error) in
                        // 삭제 실패
                        UIAlertController.showMessage(error.localizedDescription)
                    })
                    
                }),
                UIAlertAction(title: "확인", style: .default, handler: nil)]
            )
            
        }, failure: { (error) in
            
            // 업로드 실패
            UIAlertController.showMessage(error.localizedDescription)
            
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func scrapRemoteImage() -> Void {
        
        // 원격지 이미지 URL
        let imageURL = URL(string: "http://t1.kakaocdn.net/kakaocorp/pw/kakao/ci_kakao.gif")!

        KLKImageStorage.shared().scrap(withImageURL: imageURL, success: { (original) in
            
            // 업로드 성공
            UIAlertController.showAlert(title: "", message: "업로드 성공\n\(original.url)", actions: [
                UIAlertAction(title: "삭제", style: .default, handler: { (alertAction) in
                    
                    // 업로드된 이미지 삭제
                    KLKImageStorage.shared().delete(withImageURL: original.url, success: {
                        // 삭제 성공
                        UIAlertController.showMessage("삭제 성공")
                    }, failure: { (error) in
                        // 삭제 실패
                        UIAlertController.showMessage(error.localizedDescription)
                    })
                    
                }),
                UIAlertAction(title: "확인", style: .default, handler: nil)]
            )
            
        }, failure: { (error) in
            
            // 업로드 실패
            UIAlertController.showMessage(error.localizedDescription)
            
        })
    }
    
    func showChooseSharingFile() {
        UIAlertController.showAlert(title: "", message: "공유 파일?", actions: [
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil),
            UIAlertAction(title: "JPG", style: .default, handler: { (alertAction) in
                self.shareFile(Bundle.main.url(forResource: "test_img", withExtension: "jpg"))
            }),
            UIAlertAction(title: "MP4", style: .default, handler: { (alertAction) in
                self.shareFile(Bundle.main.url(forResource: "test_vod", withExtension: "mp4"))
            }),
            UIAlertAction(title: "TXT", style: .default, handler: { (alertAction) in
                self.shareFile(Bundle.main.url(forResource: "test_text", withExtension: "txt")) // kakaotalk not support yet.
            }),
            UIAlertAction(title: "GIF", style: .default, handler: { (alertAction) in
                self.shareFile(Bundle.main.url(forResource: "test_gif", withExtension: "gif")) // kakaotalk not support yet.
            }),
        ])
    }
    
    func shareFile(_ localPath: URL?) {
        if let localPath = localPath {
            documentController = UIDocumentInteractionController(url: localPath)
            documentController?.delegate = self
            documentController?.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
        }
    }
    
    func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
        self.documentController = nil
    }
    
    func dummyStoryLinkURLString() -> String! {
        let bundle = Bundle.main
        var scrapInfo = ScrapInfo()
        scrapInfo.title = "Sample"
        scrapInfo.desc = "Sample 입니다."
        scrapInfo.imageUrls = ["http://www.daumkakao.com/images/operating/temp_mov.jpg"]
        scrapInfo.type = ScrapType.Video
        
        if let bundleId = bundle.bundleIdentifier, let appVersion: String = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let appName: String = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String {
                
            return StoryLinkHelper.makeStoryLink("Sample Story Posting https://www.youtube.com/watch?v=XUX1jtTKkKs",
                appBundleId: bundleId, appVersion: appVersion, appName: appName, scrapInfo: scrapInfo)
        }
        
        return nil;
    }
    
    func postStory() {
        if !StoryLinkHelper.canOpenStoryLink() {
            print("Cannot open kakao story.")
            return
        }
        
        if let urlString = dummyStoryLinkURLString() {
            _ = StoryLinkHelper.openStoryLink(urlString)
        }
    }
}

