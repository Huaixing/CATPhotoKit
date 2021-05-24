//
//  CATAlbumViewController.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/4.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import "CATAlbumViewController.h"
#import "CATPhotoViewController.h"
#import "CATPhotoPickerController.h"

#import "CATLibrary.h"
#import "CATAlbumCell.h"
#import "NSString+Bundle.h"
#import "CATAuthorizedTipView.h"

#import <CATCommonKit.h>

@interface CATAlbumViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<CATAlbum *> *albums;
@property (nonatomic, strong) UITableView *albumTableView;

/**loading*/
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
/**no auth*/
@property (nonatomic, strong) CATAuthorizedTipView *noneAuthorizedTipView;
/**limit auth*/
@property (nonatomic, strong) CATAuthorizedTipView *limitAuthorizedTipView;

@end

@implementation CATAlbumViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.title = [self barTitle];
    self.navigationBar.leftBarButton = [CATPhotoBarButton barButtonWithBarButtonType:CATPhotoBarButtonCancel target:self action:@selector(leftButtonClick)];
    
    [self.view addSubview:self.loadingView];
    [self.view addSubview:self.albumTableView];
    [self.view addSubview:self.noneAuthorizedTipView];
    [self.view addSubview:self.limitAuthorizedTipView];
    
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    
    @weakify(self);
    [CATLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        @strongify(self);
        if (!self) return;

        [self.loadingView stopAnimating];
        [self handleAuthorizedStatus:status];
    }];
}

- (void)dealloc {
    NSLog(@" CATAlbumViewController ----- dealloc");
}


#pragma mark - Method
/// 处理授权后的逻辑
/// @param status 授权后的状态
- (void)handleAuthorizedStatus:(PHAuthorizationStatus)status {
    if (@available(iOS 14.0, *)) {
        if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
            /// 拒绝授权/未被授权
            [self handleUnAuthorizationStatus];
        } else if (status == PHAuthorizationStatusLimited) {
            /// 授权部分照片可以访问
            [self handleLimitedAuthorizationStatus];
        } else if (status == PHAuthorizationStatusAuthorized) {
            /// 授权全部照片可以访问
            [self handleAuthorizationStatus];
        }
        
    } else {
        if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
            /// 拒绝授权/未被授权
            [self handleUnAuthorizationStatus];
        } else if (status == PHAuthorizationStatusAuthorized) {
            /// 授权全部照片可以访问
            [self handleAuthorizationStatus];
        }
    }
}

- (void)handleUnAuthorizationStatus {
    self.noneAuthorizedTipView.hidden = NO;
}

- (void)handleLimitedAuthorizationStatus {
    self.limitAuthorizedTipView.hidden = NO;
}

- (void)handleAuthorizationStatus {
    [[CATPhotoManager shareManager] fetchAlbumsWithAfterSmartAlbumUserLibraryHandler:^(NSArray<CATAlbum *> *albums) {

        if ([self shouldAutoIntoLibrary]) {
            // 自动进入照片列表页面
            [self pushPhotoControllerAlbum:[albums firstObject] animated:NO];
        }

    } complete:^(NSArray<CATAlbum *> *albums) {
        
        [self.view addSubview:self.albumTableView];
        self.albumTableView.hidden = NO;

        [self.albums removeAllObjects];
        [self.albums addObjectsFromArray:albums];

        [self.albumTableView reloadData];
    }];
}


#pragma mark - Event
- (void)leftButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleContinueLimitAuth {
    self.limitAuthorizedTipView.hidden = YES;
    [self handleAuthorizationStatus];
}

#pragma mark - Getter

- (NSMutableArray<CATAlbum *> *)albums {
    if (!_albums) {
        _albums = [[NSMutableArray alloc] init];
    }
    return _albums;
}

- (UITableView *)albumTableView {
    if (!_albumTableView) {
        _albumTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _albumTableView.backgroundColor = [UIColor clearColor];
        _albumTableView.delegate = self;
        _albumTableView.dataSource = self;
        _albumTableView.cellLayoutMarginsFollowReadableWidth = NO;
        _albumTableView.estimatedRowHeight = 0;
        _albumTableView.estimatedSectionHeaderHeight = 0;
        _albumTableView.estimatedSectionFooterHeight = 0;
        _albumTableView.hidden = YES;
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
        _loadingView.hidden = YES;
    }
    return _loadingView;
}

- (CATAuthorizedTipView *)noneAuthorizedTipView {
    if (!_noneAuthorizedTipView) {
        _noneAuthorizedTipView = [[CATAuthorizedTipView alloc] initNoneAuthViewWithFrame:self.view.bounds];
        _noneAuthorizedTipView.hidden = YES;
    }
    return _noneAuthorizedTipView;
}

- (CATAuthorizedTipView *)limitAuthorizedTipView {
    if (!_limitAuthorizedTipView) {
        _limitAuthorizedTipView = [[CATAuthorizedTipView alloc] initLimitAuthViewWithFrame:self.view.bounds];
        _limitAuthorizedTipView.hidden = YES;
        
        @weakify(self);
        _limitAuthorizedTipView.handleAction = ^{
            @strongify(self);
            [self handleContinueLimitAuth];
        };
    }
    return _limitAuthorizedTipView;
}

#pragma mark - Private

/// 是否自动进入全部照片相册
- (BOOL)shouldAutoIntoLibrary {
    return (((CATPhotoPickerController *)self.navigationController).autoIntoLibrary);
}

/// 是否自动进入全部照片相册
- (NSString *)barTitle {
    return (((CATPhotoPickerController *)self.navigationController).title);
}

- (void)pushPhotoControllerAlbum:(CATAlbum *)album animated:(BOOL)animated {
    if (!album) {
        return;
    }
    CATPhotoViewController *photoController = [[CATPhotoViewController alloc] init];
    photoController.album = album;
    [self.navigationController pushViewController:photoController animated:animated];
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
    
    if (indexPath.row < self.albums.count) {
        CATAlbum *album = [self.albums objectAtIndex:indexPath.row];
        [self pushPhotoControllerAlbum:album animated:YES];
    }
    
}

@end
