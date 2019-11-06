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

#import "TalkProfileViewController.h"
#import "TalkProfileTableViewCell.h"
#import "ProfileImageViewController.h"
#import "UIAlertController+Addition.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface TalkProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) KOTalkProfile *profile;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGesture;

@end

@implementation TalkProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageTapped:)];
    _singleTapGesture.numberOfTapsRequired = 1;
    _singleTapGesture.numberOfTouchesRequired = 1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UINib *nib = [UINib nibWithNibName:@"TalkProfileTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TalkProfileTableViewCell"];
    
    [KOSessionTask talkProfileTaskWithCompletionHandler:^(id result, NSError *error) {
        if (error) {
            [UIAlertController showMessage:error.description];
        } else {
            self.profile = result;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TalkProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TalkProfileTableViewCell"];
    [cell setTalkProfile:_profile];
    
    BOOL hasGesture = NO;
    for (UIGestureRecognizer *gesture in [cell.thumbnail gestureRecognizers]) {
        if (gesture == _singleTapGesture) {
            hasGesture = YES;
            break;
        }
    }
    
    if (!hasGesture) {
        [cell.thumbnail addGestureRecognizer:_singleTapGesture];
        cell.thumbnail.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 236;
}

- (void)profileImageTapped:(UITapGestureRecognizer *)recognizer {
    if (!_profile || _profile.profileImageURL.length == 0) {
        return;
    }
    
    [self performSegueWithIdentifier:@"ProfileImage" sender:_profile.profileImageURL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ProfileImage"]) {
        ProfileImageViewController *viewController = segue.destinationViewController;
        viewController.profileImageUrlString = sender;
    }
}

@end
