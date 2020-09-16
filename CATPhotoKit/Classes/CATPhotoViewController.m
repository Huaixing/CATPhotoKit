//
//  CATPhotoViewController.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/4.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import "CATPhotoViewController.h"

#import "CATPhotoPickerController.h"
#import <CATCommonKit/CATCommonKit.h>

#import "CATLibrary.h"
#import "CATAlbum.h"
#import "CATPhotoCell.h"
#import "CATPhoto.h"
#import "CATPhotoSelectedBar.h"


@interface CATPhotoViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, CATPhotoCellDelegate, CATPhotoSelectedBarDelegate>
/***/
@property (nonatomic, strong) NSMutableArray<CATPhoto *> *photos;
@property (nonatomic, strong) UICollectionView *collectionView;
/// 底部选择栏
@property (nonatomic, strong) CATPhotoSelectedBar *selectedBar;


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
    self.view.backgroundColor = [UIColor whiteColor];
    
    _selectedBar = [[CATPhotoSelectedBar alloc] init];
    _selectedBar.delegate = self;
    [self.view addSubview:_selectedBar];
    CGFloat barHeight = 54 + [UIView bottomInset];
    _selectedBar.frame = CGRectMake(0, self.view.height - barHeight, self.view.width, barHeight);
    
    
    _columns = ((CATPhotoPickerController *)self.navigationController).columns;
    _space = ((CATPhotoPickerController *)self.navigationController).space;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - barHeight) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    if (@available(iOS 11.0, *)) {
//        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[CATPhotoCell class] forCellWithReuseIdentifier:CATPhotoIdentifier];
    
    __weak typeof(self) wself = self;
    [[CATPhotoManager shareManager] fetchPhotosWithCollection:self.album.collection config:nil handler:^(NSArray<CATPhoto *> *photos) {
        __strong typeof(wself) sself = wself;
        if (!sself) return;
        [sself.photos removeAllObjects];
        [sself.photos addObjectsFromArray:photos];
        [sself.collectionView reloadData];
        // 滚动最近照片的位置
        if (photos.count) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(photos.count - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        }
    }];
}


- (void)dealloc {
    NSLog(@" CATPhotoViewController ----- dealloc");
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
    cell.photo = photo;
    cell.delegate = self;
    return cell;
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
- (void)photoCell:(CATPhotoCell *)photoCell didSelectedPhoto:(CATPhoto *)photo {
    
    if (photo.isSelected) {
        [self.seletedPhotos addObject:photo];
    } else {
        [self.seletedPhotos removeObject:photo];
    }
    _selectedBar.count = self.seletedPhotos.count;
}

#pragma mark - CATPhotoSelectedBarDelegate
- (void)photoSelectedBarDidClickDone:(CATPhotoSelectedBar *)seletedBar {
    // 回传给导航栏，让导航栏跟外界交涉。最后的结果都将以导航栏的形式传给外界
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
