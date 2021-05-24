//
//  CATPhotoViewController.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/4.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import "CATPhotoViewController.h"

#import "CATPhotoPickerController.h"

#import "CATLibrary.h"
#import "CATAlbum.h"
#import "CATPhotoCell.h"
#import "CATPhoto.h"
#import "CATPhotoGridBar.h"
#import "NSString+Bundle.h"
#import <CATCommonKit.h>


@interface CATPhotoViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, CATPhotoCellDelegate, CATPhotoGridBarDelegate>
/***/
@property (nonatomic, strong) NSMutableArray<CATPhoto *> *photos;
@property (nonatomic, strong) UICollectionView *collectionView;
/// 底部选择栏
@property (nonatomic, strong) CATPhotoGridBar *selectedBar;


/**照片列表中一行多少个，default 4*/
@property (nonatomic, assign, readonly) NSUInteger columns;

/**照片列表中每两个照片之间的间距，default 1.0*/
@property (nonatomic, assign, readonly) CGFloat space;
/// 选中的照片
@property (nonatomic, strong) NSMutableArray<CATPhoto *> *seletedPhotos;
@end

static NSString *CATPhotoIdentifier = @"PhotoCell";
@implementation CATPhotoViewController

#pragma mark - Left

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /// 导航栏
    self.navigationBar.leftBarButton = [CATPhotoBarButton barButtonWithBarButtonType:CATPhotoBarButtonBack target:self action:@selector(leftButtonClick)];
    
    _selectedBar = [[CATPhotoGridBar alloc] init];
    _selectedBar.delegate = self;
    [self.view addSubview:_selectedBar];
    CGFloat barHeight = 54 + [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    _selectedBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - barHeight, CGRectGetWidth(self.view.frame), barHeight);
    _selectedBar.hidden = ![self canMultiplePick];
    
    
    _columns = ((CATPhotoPickerController *)self.navigationController).columns;
    _space = ((CATPhotoPickerController *)self.navigationController).space;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - (_selectedBar.isHidden ? 0 : CGRectGetHeight(_selectedBar.frame))) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[CATPhotoCell class] forCellWithReuseIdentifier:CATPhotoIdentifier];
    
    @weakify(self);
    [[CATPhotoManager shareManager] fetchPhotosWithCollection:self.album.collection config:nil handler:^(NSArray<CATPhoto *> *photos) {
        @strongify(self);
        if (!self) return;
        [self.photos removeAllObjects];
        [self.photos addObjectsFromArray:photos];
        [self.collectionView reloadData];
        // 滚动最近照片的位置
        if (photos.count) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(photos.count - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        }
    }];
}


- (void)dealloc {
    NSLog(@" CATPhotoViewController ----- dealloc");
}

#pragma mark - Private

/// 是否支持多选（多选只针对照片）
- (BOOL)canMultiplePick {
    if (![self.navigationController isKindOfClass:[CATPhotoPickerController class]]) {
        return NO;
    }
    return ((CATPhotoPickerController *)self.navigationController).pickMode == CATPickModeMultiplePick;
}
/// 照片勾选数量上限，default 9
- (NSUInteger)limitPhotoCount {
    if (![self.navigationController isKindOfClass:[CATPhotoPickerController class]]) {
        return 0;
    }
    return ((CATPhotoPickerController *)self.navigationController).limitPhotoCount;
}

#pragma mark - Event
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter
- (NSMutableArray<CATPhoto *> *)photos {
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (NSMutableArray<CATPhoto *> *)seletedPhotos {
    if (!_seletedPhotos) {
        _seletedPhotos = [[NSMutableArray alloc] init];
    }
    return _seletedPhotos;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CATPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CATPhotoIdentifier forIndexPath:indexPath];
    CATPhoto *photo = [self.photos objectAtIndex:indexPath.item];
    cell.delegate = self;
    cell.canMultiplePick = [self canMultiplePick];
    cell.photo = photo;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![self canMultiplePick]) {
        // 直接选中该Asset
        [self.seletedPhotos removeAllObjects];
        if (indexPath.item < self.photos.count) {
            CATPhoto *photo = [self.photos objectAtIndex:indexPath.item];
            [self.seletedPhotos addObject:photo];
        }
        if (self.seletedPhotos.count) {
            [self photoSelectedBarDidClickDone:nil];
        }
        return;
    }
    // 浏览大图
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemWH = (CGRectGetWidth(self.view.frame) - (_columns + 1) * _space) / _columns;
    return CGSizeMake(itemWH, itemWH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return _space;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _space;
}

#pragma mark - CATPhotoCellDelegate
- (BOOL)photoCell:(CATPhotoCell *)photoCell shouldSelectedPhoto:(CATPhoto *)photo {
    if (![self canMultiplePick]) {
        return NO;
    }
    if (!photo.isSelected) {
        // 将要勾选
        if (self.seletedPhotos.count >= [self limitPhotoCount]) {
            // 勾选已达上限，toast
            NSString *message = [NSString stringWithFormat:[NSString localizationString:@"photo_kit_picker_photo_limit_count"], self.seletedPhotos.count];
            [self showAlertWithMessage:message];
            return NO;
        }
    }
    return YES;
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString localizationString:@"photo_kit_limit_alert_ok"] style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)photoCell:(CATPhotoCell *)photoCell didSelectedPhoto:(CATPhoto *)photo {
    
    if (photo.isSelected) {
        [self.seletedPhotos addObject:photo];
    } else {
        [self.seletedPhotos removeObject:photo];
    }
    _selectedBar.count = self.seletedPhotos.count;
}

#pragma mark - CATPhotoGridBarDelegate
- (void)photoSelectedBarDidClickDone:(CATPhotoGridBar *)selectedBar {
    /// 回传给导航栏，让导航栏跟外界交涉。最后的结果都将以导航栏的形式传给外界
    if (self.navigationController) {
        SEL selector = NSSelectorFromString(@"photoViewControllerDidFinishPickPhotos:");
        if ([self.navigationController respondsToSelector:selector]) {
            IMP imp = [self.navigationController methodForSelector:selector];
            void (*func)(id, SEL, NSArray *) = (void *)imp;
            func (self.navigationController, selector, self.seletedPhotos);
        }
    }
}


@end
