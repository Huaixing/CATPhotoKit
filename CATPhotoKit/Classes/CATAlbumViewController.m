//
//  CATAlbumViewController.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/4.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import "CATAlbumViewController.h"
#import "CATPhotoViewController.h"

#import "CATLibrary.h"
#import "CATAlbumCell.h"
#import "CATNoAuthorizedView.h"

@interface CATAlbumViewController ()<UITableViewDataSource, UITableViewDelegate>

/***/
@property (nonatomic, strong) NSMutableArray *albums;
/***/
@property (nonatomic, strong) UITableView *albumTableView;

/**loading*/
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
/**no auth*/
@property (nonatomic, strong) CATNoAuthorizedView *authorizedDefaultView;

@end

@implementation CATAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Album";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimating];
    
    __weak typeof(self) wself = self;
    [CATLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        __strong typeof(wself) sself = wself;
        if (!sself) return;
        if (status == PHAuthorizationStatusAuthorized) {
            [[CATPhotoManager shareManager] fetchAlbumsWithHandler:^(NSArray<CATAlbum *> *albums) {
                
                [sself.loadingView stopAnimating];
                [sself.view addSubview:self.albumTableView];
                
                [sself.albums removeAllObjects];
                [sself.albums addObjectsFromArray:albums];
                
                [sself.albumTableView reloadData];
            }];
        } else {
            [sself.loadingView stopAnimating];
            [sself.view addSubview:sself.authorizedDefaultView];
        }
    }];
}

- (void)dealloc {
    NSLog(@" CATAlbumViewController ----- dealloc");
}

#pragma mark - Getter

- (NSMutableArray *)albums {
    if (!_albums) {
        _albums = [[NSMutableArray alloc] init];
    }
    return _albums;
}

- (UITableView *)albumTableView {
    if (!_albumTableView) {
        _albumTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _albumTableView.backgroundColor = [UIColor whiteColor];
        _albumTableView.delegate = self;
        _albumTableView.dataSource = self;
        if (@available(iOS 9.0, *)) {
            _albumTableView.cellLayoutMarginsFollowReadableWidth = NO;
        } else {
            // Fallback on earlier versions
        }
        _albumTableView.estimatedRowHeight = 0;
        _albumTableView.estimatedSectionHeaderHeight = 0;
        _albumTableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
//        _albumTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _albumTableView;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        if (@available(iOS 13.0, *)) {
            _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        } else {
            _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        
        _loadingView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2.0, CGRectGetHeight(self.view.frame) / 2.0);
        _loadingView.hidesWhenStopped = YES;
    }
    return _loadingView;
}

- (CATNoAuthorizedView *)authorizedDefaultView {
    if (!_authorizedDefaultView) {
        _authorizedDefaultView = [[CATNoAuthorizedView alloc] initWithFrame:self.view.bounds iconName:nil message:@"的说法会计师大黄蜂科技大厦发了多少佛假动画的递交打回道德经复核耶耶大黄蜂科技大厦发了多少佛假动画的递交打回道德经复核耶耶大黄蜂科技大厦发了多少佛假动画的递交打回道德经复核耶耶大黄蜂科技大厦发了多少佛假动画的递交打回道德经复核耶耶大黄蜂科技大厦发了多少佛假动画的递交打回道德经复核耶耶大黄蜂科技大厦发了多少佛假动画的递交打回道德经复核耶耶耶"];
    }
    return _authorizedDefaultView;
}


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"albumCell";
    CATAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CATAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    CATAlbum *album = [self.albums objectAtIndex:indexPath.row];
    cell.album = album;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    TestViewEmojiViewController *photoController = [[TestViewEmojiViewController alloc] init];
//    [self.navigationController pushViewController:photoController animated:YES];
    
    CATAlbum *album = [self.albums objectAtIndex:indexPath.row];
    CATPhotoViewController *photoController = [[CATPhotoViewController alloc] init];
    photoController.album = album;
    [self.navigationController pushViewController:photoController animated:YES];
}

@end
