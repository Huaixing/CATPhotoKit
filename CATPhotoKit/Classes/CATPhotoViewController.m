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


@interface CATPhotoViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
/***/
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) UICollectionView *collectionView;


/**照片列表中一行多少个，default 4*/
@property (nonatomic, assign, readonly) NSUInteger columns;

/**照片列表中每两个照片之间的间距，default 1.0*/
@property (nonatomic, assign, readonly) CGFloat space;
@end

static NSString *CATPhotoIdentifier = @"PhotoCell";
@implementation CATPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _columns = ((CATPhotoPickerController *)self.navigationController).columns;
    _space = ((CATPhotoPickerController *)self.navigationController).space;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[CATPhotoCell class] forCellWithReuseIdentifier:CATPhotoIdentifier];
    
    __weak typeof(self) wself = self;
    [[CATPhotoManager shareManager] fetchPhotosWithCollection:self.album.collection config:nil handler:^(NSArray<CATPhoto *> *photos) {
        __strong typeof(wself) sself = wself;
        if (!sself) return;
        [sself.photos removeAllObjects];
        [sself.photos addObjectsFromArray:photos];
        [sself.collectionView reloadData];
        if (photos.count) {

//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:photos.count inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        }
    }];
}


- (void)dealloc {
    NSLog(@" CATPhotoViewController ----- dealloc");
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CATPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CATPhotoIdentifier forIndexPath:indexPath];
    CATPhoto *photo = [self.photos objectAtIndex:indexPath.item];
    cell.photo = photo;
    return cell;
}


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
@end
