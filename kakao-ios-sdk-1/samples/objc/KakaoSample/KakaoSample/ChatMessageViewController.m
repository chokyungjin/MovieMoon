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

#import "ChatMessageViewController.h"
#import "ThumbnailImageViewCell.h"
#import "UIAlertController+Addition.h"
#import "UIImageView+WebCache.h"
#import "ConfigConstants.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface ChatMessageViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) NSMutableArray *allChats;
@property (strong, nonatomic) NSMutableArray *filteredChats;
@property (strong, nonatomic) NSString *searchText;

@property (strong, nonatomic) KOChatContext *chatContext;

@property (weak, nonatomic) KOChat *selectedChat;
@property (assign, nonatomic) NSInteger limitCount;
@property (assign, nonatomic, getter=isRequesting) BOOL requesting;

@end

@implementation ChatMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatContext = [KOChatContext contextWithChatFilters:KOChatFilterNone limit:30 ordering:KOOrderingAscending];
    self.allChats = [NSMutableArray array];
    self.filteredChats = [NSMutableArray array];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchBar.delegate = self;
    searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController = searchController;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self requestChatList];
}

- (void)updateViews {
    [self.filteredChats removeAllObjects];
    [self.allChats enumerateObjectsUsingBlock:^(KOChat * _Nonnull chat, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.searchText.length == 0 || [chat.title rangeOfString:self.searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [self.filteredChats addObject:chat];
        }
    }];
    [self.tableView reloadData];
}

- (void)requestChatList {
    if (self.chatContext == nil) {
        NSLog(@"chatContext must be setup.");
        return;
    }
    
    if (self.isRequesting || !self.chatContext.hasMoreItems) {
        return;
    }
    
    self.requesting = YES;
    [KOSessionTask talkChatListTaskWithContext:self.chatContext completionHandler:^(NSArray *chats, NSError *error) {
        if (error) {
            NSLog(@"chats error = %@", error);
            if (error.code == KOErrorCancelled) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            self.title = [NSString stringWithFormat:@"Chat (%@)", self.chatContext.totalCount];
            [self.allChats addObjectsFromArray:chats];
            [self updateViews];
        }
        
        self.requesting = NO;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredChats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[ThumbnailImageViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    KOChat *chat = self.filteredChats[indexPath.row];
    
    cell.textLabel.text = chat.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Members : %@", chat.memberCount];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:chat.thumbnailURL]
                      placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
    
    NSInteger count = self.filteredChats.count;
    if (indexPath.row > (count - count / 3)) {
        [self requestChatList];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedChat = self.filteredChats[indexPath.row];
    
    [UIAlertController showAlertWithTitle:@""
                                  message:@"Send Message?"
                                  actions:@[[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil],
                                            [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                       [self sendTemplateMessage];
                                                                   }]
                                            ]];
}

- (void)sendTemplateMessage {
    if (self.selectedChat == nil) {
        return;
    }
    
    [self.selectedChat sendMessageWithTemplateId:MESSAGE_FEED_TEMPLATE_ID
                                    templateArgs:nil
                               completionHandler:^(NSError *error) {
                                   if (error) {
                                       if (error.code != KOErrorOperationInProgress) {
                                           [UIAlertController showMessage:[NSString stringWithFormat:@"message send failed = %@", error]];
                                       }
                                   } else {
                                       [UIAlertController showMessage:@"message send succeed."];
                                   }
                               }];

    self.selectedChat = nil;
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
