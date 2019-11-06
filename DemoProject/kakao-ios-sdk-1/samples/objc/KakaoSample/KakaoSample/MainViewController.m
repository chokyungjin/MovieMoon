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

#import "MainViewController.h"
#import "IconTableViewCell.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController {
    NSArray *_apiMenus;
    NSArray *_menuSubTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _apiMenus = @[@"User API", @"Story API", @"Message API", @"Message API"];
    _menuSubTitles = @[@"", @"", @"(Friend)", @"(Chat)"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (IBAction)logoutClicked:(id)sender {
    __weak MainViewController *wself = self;
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        [wself.navigationController popViewControllerAnimated:YES];
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _apiMenus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IconTableViewCell"];
    if (cell == nil) {
        cell = [[IconTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IconTableViewCell"];
    }
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"MainMenuIcon%d", (int) indexPath.row]];
    cell.textLabel.text = _apiMenus[indexPath.row];
    cell.detailTextLabel.text = _menuSubTitles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:[NSString stringWithFormat:@"%@%@", _apiMenus[indexPath.row], _menuSubTitles[indexPath.row]]
                              sender:_apiMenus[indexPath.row]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *viewController = segue.destinationViewController;
    viewController.title = sender;
}

@end
