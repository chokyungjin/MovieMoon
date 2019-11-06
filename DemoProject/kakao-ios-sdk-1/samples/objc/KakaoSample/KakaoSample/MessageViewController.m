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

#import "MessageViewController.h"
#import "ThumbnailImageViewCell.h"
#import "UIAlertController+Addition.h"
#import "UIImageView+WebCache.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import <KakaoMessageTemplate/KakaoMessageTemplate.h>
#import "ConfigConstants.h"

typedef NS_ENUM (NSInteger, TalkFriendOptionType) {
    TalkFriendOptionTypeAll = 1,
    TalkFriendOptionTypeInvitable,
    TalkFriendOptionTypeRegistered
};

@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) NSMutableArray *allFriends;
@property (strong, nonatomic) NSMutableArray *filteredFriends;
@property (strong, nonatomic) NSString *searchText;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allFriends = [NSMutableArray array];
    self.filteredFriends = [NSMutableArray array];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchBar.delegate = self;
    searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController = searchController;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self requestFriends:[KOAppFriendContext contextWithLimit:100 ordering:KOOrderingAscending]];
}

- (void)updateViews {
    [self.filteredFriends removeAllObjects];
    [self.allFriends enumerateObjectsUsingBlock:^(KOAppFriend *_Nonnull friend, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.searchText.length == 0 || [friend.nickname rangeOfString:self.searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [self.filteredFriends addObject:friend];
        }
    }];
    [self.tableView reloadData];
}

- (void)requestFriends:(KOAppFriendContext *)friendContext {
    
    // 친구 목록 조회
    
    [KOSessionTask appFriendsWithContext:friendContext
                       completionHandler:^(NSError * _Nullable error,
                                           NSArray<KOAppFriend *> * _Nullable appFriends) {
                           
                           if (appFriends) {
                               [self.allFriends addObjectsFromArray:appFriends];
                               if (friendContext.hasMoreItems) {
                                   [self requestFriends:friendContext];
                               } else {
                                   [self updateViews];
                               }
                           } else {
                               NSLog(@"%@", error);
                               if (error.code == KOErrorCancelled) {
                                   [self.navigationController popViewControllerAnimated:YES];
                               } else {
                                   [UIAlertController showMessage:error.description];
                               }
                           }
                       }];
}

- (void)requestMessageSendWithTemplate:(KMTTemplate *)template receiverUuids:(NSArray<NSString *> *)receiverUuids {
    
    // 기본 템플릿 메시지 보내기
    
    [KOSessionTask sendMessageToFriendsWithTemplate:template
                                      receiverUuids:receiverUuids
                                  completionHandler:^(NSArray<NSString *> * _Nullable successfulReceiverUuids,
                                                      NSArray<NSError *> * _Nullable failureInfo,
                                                      NSError * _Nullable error) {
                                      
                                      if (successfulReceiverUuids) {
                                          NSMutableString *message = [NSMutableString string];
                                          [message appendFormat:@"메시지 보내기 성공!\n%@", successfulReceiverUuids];
                                          
                                          if (failureInfo) {
                                              [message appendFormat:@"\n부분 실패: %@", failureInfo];
                                          }
                                          [UIAlertController showMessage:message];
                                          
                                      } else {
                                          NSLog(@"%@", error);
                                          if (error.code != KOErrorCancelled) {
                                              [UIAlertController showMessage:error.description];
                                          }
                                      }
                                  }];
}

- (void)requestMessageSendWithURL:(NSURL *)URL receiverUuids:(NSArray<NSString *> *)receiverUuids {
    
    // 스크랩 템플릿 메시지 보내기
    
    [KOSessionTask sendMessageToFriendsTaskWithURL:URL
                                     receiverUuids:receiverUuids
                                 completionHandler:^(NSArray<NSString *> * _Nullable successfulReceiverUuids,
                                                     NSArray<NSError *> * _Nullable failureInfo,
                                                     NSError * _Nullable error) {
                                     
                                     if (successfulReceiverUuids) {
                                         NSMutableString *message = [NSMutableString string];
                                         [message appendFormat:@"메시지 보내기 성공!\n%@", successfulReceiverUuids];
                                         
                                         if (failureInfo) {
                                             [message appendFormat:@"\n부분 실패: %@", failureInfo];
                                         }
                                         [UIAlertController showMessage:message];
                                         
                                     } else {
                                         NSLog(@"%@", error);
                                         if (error.code != KOErrorCancelled) {
                                             [UIAlertController showMessage:error.description];
                                         }
                                     }
                                 }];
}

- (void)requestMessageSendWithTemplateId:(NSString *)templateId receiverUuids:(NSArray<NSString *> *)receiverUuids {
    
    // 커스텀 템플릿 메시지 보내기
    
    [KOSessionTask sendMessageToFriendsTaskWithTemplateId:templateId
                                             templateArgs:nil
                                            receiverUuids:receiverUuids
                                        completionHandler:^(NSArray<NSString *> * _Nullable successfulReceiverUuids,
                                                            NSArray<NSError *> * _Nullable failureInfo,
                                                            NSError * _Nullable error) {
                                            
                                            if (successfulReceiverUuids) {
                                                NSMutableString *message = [NSMutableString string];
                                                [message appendFormat:@"메시지 보내기 성공!\n%@", successfulReceiverUuids];
                                                
                                                if (failureInfo) {
                                                    [message appendFormat:@"\n부분 실패: %@", failureInfo];
                                                }
                                                [UIAlertController showMessage:message];
                                                
                                            } else {
                                                NSLog(@"%@", error);
                                                if (error.code != KOErrorCancelled) {
                                                    [UIAlertController showMessage:error.description];
                                                }
                                            }
                                        }];
}

- (KMTFeedTemplate *)defaultFeedTemplate {
    return [KMTFeedTemplate feedTemplateWithBuilderBlock:^(KMTFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {
        feedTemplateBuilder.content = [KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"베리베리 치즈 케익";
            contentBuilder.desc = @"#케익 #딸기 #블루베리 #카페 #디저트 #달달함 #분위기 #삼평동";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://k.kakaocdn.net/dn/bDgfik/btqwQWk4CRU/P6wNJJiQ3Ko21KNE1TiLw1/kakaolink40_original.png"];
            contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
                linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }];
        feedTemplateBuilder.social = [KMTSocialObject socialObjectWithBuilderBlock:^(KMTSocialBuilder * _Nonnull socialBuilder) {
            socialBuilder.likeCount = @(286);
            socialBuilder.commnentCount = @(45);
            socialBuilder.sharedCount = @(845);
        }];
        [feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"웹으로 보기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
                linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        [feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"앱으로 열기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.iosExecutionParams = @"param1=value1&param2=value2";
                linkBuilder.androidExecutionParams = @"param1=value1&param2=value2";
            }];
        }]];
    }];
}

- (KMTListTemplate *)defaultListTemplate {
    return [KMTListTemplate listTemplateWithBuilderBlock:^(KMTListTemplateBuilder * _Nonnull listTemplateBuilder) {
        listTemplateBuilder.headerTitle = @"WEEKLY MAGAZINE";
        listTemplateBuilder.headerLink = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
            linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
        }];
        [listTemplateBuilder addContent:[KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"오직 당신만을 위한 책을 만들어 드립니다.";
            contentBuilder.desc = @"브런치팀";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://k.kakaocdn.net/dn/j8Oiy/btqwRCGGjrl/9WxQofSJNnk6KzhbCiunD1/kakaolink40_original.png"];
            contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
                linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        [listTemplateBuilder addContent:[KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"우리 함께 책 읽어요. 가볍게 시작하는 독서";
            contentBuilder.desc = @"도서";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://k.kakaocdn.net/dn/kIxII/btqwP7m6Rkb/PpnGXt72ToNhy9fgAvC5Kk/kakaolink40_original.png"];
            contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
                linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        [listTemplateBuilder addContent:[KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"아이와 함께하는 음식이야기 - 베이킹편";
            contentBuilder.desc = @"음식";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://k.kakaocdn.net/dn/XlVQM/btqwOr7IFSG/uR2xkgzhH0S6TOFF9wkMRK/kakaolink40_original.png"];
            contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
                linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        [listTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"웹으로 보기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
                linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        [listTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"앱으로 열기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.iosExecutionParams = @"param1=value1&param2=value2";
                linkBuilder.androidExecutionParams = @"param1=value1&param2=value2";
            }];
        }]];
    }];
}

- (KMTCommerceTemplate *)defaultCommerceTemplate {
    return [KMTCommerceTemplate commerceTemplateWithBuilderBlock:^(KMTCommerceTemplateBuilder * _Nonnull commerceTemplateBuilder) {
        commerceTemplateBuilder.content = [KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"데일리 룩으로 좋은 화이트 셔츠";
            contentBuilder.desc = @"White Shirt(1 Color)";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://k.kakaocdn.net/dn/JKZDK/btqwO690vVe/fThfikUTubQ3dA9PLYu0TK/kakaolink40_original.png"];
            contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
                linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }];
        commerceTemplateBuilder.commerce = [KMTCommerceObject commerceObjectWithBuilderBlock:^(KMTCommerceBuilder * _Nonnull commerceBuilder) {
            commerceBuilder.regularPrice = @(30000);
            commerceBuilder.discountPrice = @(21000);
            commerceBuilder.discountRate = @(30);
        }];
        [commerceTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"구매하기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
                linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        [commerceTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"공유하기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
                linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
    }];
}

- (KMTLocationTemplate *)defaultLocationTemplate {
    return [KMTLocationTemplate locationTemplateWithBuilderBlock:^(KMTLocationTemplateBuilder * _Nonnull locationTemplateBuilder) {
        locationTemplateBuilder.addressTitle = @"카카오 판교오피스 카페톡";
        locationTemplateBuilder.address = @"경기 성남시 분당구 판교역로 235 에이치스퀘어 N동 8층";
        locationTemplateBuilder.content = [KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"신메뉴 출시, 초코 브라우니";
            contentBuilder.desc = @"#브라우니 #초코 #카라멜 #아이스크림 #카페 #디저트 #달달함 #분위기 #삼평동";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://k.kakaocdn.net/dn/RWBKp/btqwRBA7BqR/fCZxTAWlQwU1kvZJaaleA0/kakaolink40_original.png"];
            contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
                linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }];
        locationTemplateBuilder.social = [KMTSocialObject socialObjectWithBuilderBlock:^(KMTSocialBuilder * _Nonnull socialBuilder) {
            socialBuilder.likeCount = @(286);
            socialBuilder.commnentCount = @(45);
            socialBuilder.sharedCount = @(845);
        }];
        [locationTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"자세히 보기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
                linkBuilder.webURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
    }];
}

- (IBAction)sendAction:(id)sender {
    NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
    if (indexPaths.count == 0) {
        return;
    }

    NSMutableArray *receiverUuids = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths) {
        KOAppFriend *friend = self.filteredFriends[indexPath.row];
        [receiverUuids addObject:friend.uuid];
    }
    
    [UIAlertController showAlertWithTitle:@"메시지 보내기"
                                  message:[NSString stringWithFormat:@"대상 UUID: %@", receiverUuids]
                                  actions:@[[UIAlertAction actionWithTitle:@"기본 템플릿 (Feed)"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                       [self requestMessageSendWithTemplate:[self defaultFeedTemplate]
                                                                                              receiverUuids:receiverUuids];
                                                                   }],
                                            [UIAlertAction actionWithTitle:@"기본 템플릿 (List)"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                       [self requestMessageSendWithTemplate:[self defaultListTemplate]
                                                                                              receiverUuids:receiverUuids];
                                                                   }],
                                            [UIAlertAction actionWithTitle:@"기본 템플릿 (Commerce)"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                       [self requestMessageSendWithTemplate:[self defaultCommerceTemplate]
                                                                                              receiverUuids:receiverUuids];
                                                                   }],
                                            [UIAlertAction actionWithTitle:@"기본 템플릿 (Location)"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                       [self requestMessageSendWithTemplate:[self defaultLocationTemplate]
                                                                                              receiverUuids:receiverUuids];
                                                                   }],
                                            [UIAlertAction actionWithTitle:@"스크랩 템플릿"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                       [self requestMessageSendWithURL:[NSURL URLWithString:@"https://developers.kakao.com"]
                                                                                         receiverUuids:receiverUuids];
                                                                   }],
                                            [UIAlertAction actionWithTitle:@"커스텀 템플릿 (Feed)"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                       [self requestMessageSendWithTemplateId:MESSAGE_FEED_TEMPLATE_ID
                                                                                                receiverUuids:receiverUuids];
                                                                   }],
                                            [UIAlertAction actionWithTitle:@"커스텀 템플릿 (List)"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                       [self requestMessageSendWithTemplateId:MESSAGE_LIST_TEMPLATE_ID
                                                                                                receiverUuids:receiverUuids];
                                                                   }],
                                            [UIAlertAction actionWithTitle:@"커스텀 템플릿 (Commerce)"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                       [self requestMessageSendWithTemplateId:MESSAGE_COMMERCE_TEMPLATE_ID
                                                                                                receiverUuids:receiverUuids];
                                                                   }],
                                            [UIAlertAction actionWithTitle:@"취소"
                                                                     style:UIAlertActionStyleCancel
                                                                   handler:nil]]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[ThumbnailImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    KOAppFriend *friend = self.filteredFriends[indexPath.row];
    NSString *nickname = friend.nickname ? friend.nickname : @"<unknown>";
    
    cell.textLabel.text = nickname;
    [cell.imageView sd_setImageWithURL:friend.thumbnailImageURL placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchText = searchText;
    [self updateViews];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.text = self.searchText;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.text = self.searchText;
}

@end
