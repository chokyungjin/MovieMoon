/**
 * Copyright 2016-2017 Kakao Corp.
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
#import <KakaoNavi/KakaoNavi.h>

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *reuseIdentifier;
@property (strong, nonatomic) NSArray *headers;
@property (strong, nonatomic) NSArray *texts;

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIButton *naviButton;

- (IBAction)execute:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reuseIdentifier = @"KakaoNaviSampleCell";
    self.headers = @[@"목적지 공유", @"목적지 길안내"];
    self.texts = @[@[@[@"카카오판교오피스", @""],
                     @[@"카카오판교오피스", @"WGS84"],],
                   @[@[@"카카오판교오피스", @"WGS84"],
                     @[@"카카오판교오피스", @"전체 경로정보 보기"],],];
    
    self.title = @"카카오내비샘플";
    
    self.naviButton.layer.cornerRadius = 5;
    self.naviButton.layer.borderWidth = 1;
    self.naviButton.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    self.naviButton.backgroundColor = [UIColor colorWithRed:(254 / 255.0) green:(238 / 255.0) blue:(53 / 255.0) alpha:1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.texts[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.headers[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:self.reuseIdentifier];
    }
    cell.textLabel.text = self.texts[indexPath.section][indexPath.row][0];
    cell.detailTextLabel.text = self.texts[indexPath.section][indexPath.row][1];
    return cell;
}

- (IBAction)execute:(id)sender {
    NSError *error = nil;
    
    if (self.menuTableView.indexPathForSelectedRow) {
        NSIndexPath *selected = self.menuTableView.indexPathForSelectedRow;
        switch (selected.section) {
            case 0:
                switch (selected.row) {
                    case 0:
                        [self shareDestination];
                        break;
                    case 1:
                        [self shareDestinationWGS84];
                        break;
                    default:
                        error = [NSError errorWithDomain:@"KakaoNaviSampleErrorDomain" code:1 userInfo:@{NSLocalizedFailureReasonErrorKey:@"존재하지 않는 메뉴입니다."}];
                        break;
                }
                break;
            case 1:
                switch (selected.row) {
                    case 0:
                        [self navigateWGS84];
                        break;
                    case 1:
                        [self navigateRouteInfo];
                        break;
                    default:
                        error = [NSError errorWithDomain:@"KakaoNaviSampleErrorDomain" code:1 userInfo:@{NSLocalizedFailureReasonErrorKey:@"존재하지 않는 메뉴입니다."}];
                        break;
                }
                break;
            default:
                error = [NSError errorWithDomain:@"KakaoNaviSampleErrorDomain" code:1 userInfo:@{NSLocalizedFailureReasonErrorKey:@"존재하지 않는 메뉴입니다."}];
                break;
        }
    } else {
        error = [NSError errorWithDomain:@"KakaoNaviSampleErrorDomain" code:2 userInfo:@{NSLocalizedFailureReasonErrorKey:@"메뉴를 선택해 주세요."}];
    }
    
    [self handleError:error];
}

- (void)shareDestination {
    
    // 목적지 공유 - 카카오판교오피스
    KNVLocation *destination = [KNVLocation locationWithName:@"카카오판교오피스" x:@(321286) y:@(533707)];
    KNVParams *params = [KNVParams paramWithDestination:destination];
    
    [[KNVNaviLauncher sharedLauncher] shareDestinationWithParams:params completion:^(NSError * _Nullable error) {
        [self handleError:error];
    }];
}

- (void)shareDestinationWGS84 {
    
    // 목적지 공유 - 카카오판교오피스 - WGS84
    KNVLocation *destination = [KNVLocation locationWithName:@"카카오판교오피스" x:@(127.1087) y:@(37.40206)];
    KNVOptions *options = [KNVOptions options];
    options.coordType = KNVCoordTypeWGS84;
    KNVParams *params = [KNVParams paramWithDestination:destination options:options];
    
    [[KNVNaviLauncher sharedLauncher] shareDestinationWithParams:params completion:^(NSError * _Nullable error) {
        [self handleError:error];
    }];
}

- (void)navigateWGS84 {
    
    // 목적지 길안내 - 카카오판교오피스 - WGS84
    KNVLocation *destination = [KNVLocation locationWithName:@"카카오판교오피스" x:@(127.1087) y:@(37.40206)];
    KNVOptions *options = [KNVOptions options];
    options.coordType = KNVCoordTypeWGS84;
    KNVParams *params = [KNVParams paramWithDestination:destination options:options];
    
    [[KNVNaviLauncher sharedLauncher] navigateWithParams:params completion:^(NSError * _Nullable error) {
        [self handleError:error];
    }];
}

- (void)navigateRouteInfo {
    
    // 목적지 길안내 - 카카오판교오피스 - 전체 경로정보 보기
    KNVLocation *destination = [KNVLocation locationWithName:@"카카오판교오피스" x:@(321286) y:@(533707)];
    KNVOptions *options = [KNVOptions options];
    options.routeInfo = YES;
    KNVParams *params = [KNVParams paramWithDestination:destination options:options];
    
    [[KNVNaviLauncher sharedLauncher] navigateWithParams:params completion:^(NSError * _Nullable error) {
        [self handleError:error];
    }];
}

- (void)handleError:(NSError *)error {
    if (error) {
        NSLog(@"%@", error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.title message:error.localizedFailureReason preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
