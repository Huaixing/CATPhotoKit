//
//  CATLibrary.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/7/28.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import "CATLibrary.h"
#import <UIKit/UIKit.h>

#import "CATAlbum.h"
#import "CATPhoto.h"

static long long PHAssetCollectionSubTypeRecentDelete = 1000000201;


/*
 1. synchronous = YES. 同步。只返回一张图片并且deliveryMode会忽略用户设置的值，直接设为 PHImageRequestOptionsDeliveryModeHighQualityFormat。
    a. resizeMode: PHImageRequestOptionsResizeModeNone: 返回的是原图大小
    b. resizeMode: PHImageRequestOptionsResizeModeFast: 当原图是压缩图时，会使用targetSize来最优解码图片，获得的图片大小可能比targetSize大
    c. resizeMode: PHImageRequestOptionsResizeModeExact: 解压和Fast一样，但是返回的是指定targetSize的高质量图
 
 
 2. synchronous: NO. 异步。
    a. deliveryMode: PHImageRequestOptionsDeliveryModeOpportunistic: 会返回多张图片
        1). PHImageRequestOptionsResizeModeNone: 先返回低清的缩略图，再返回原图大小
        2). PHImageRequestOptionsResizeModeFast: 先返回低清的缩略图，再返回的图片如 1-b 一样
        3). PHImageRequestOptionsResizeModeExact: 先返回低清的缩略图，再返回的图片如 1-c一样
 
    b. deliveryMode: PHImageRequestOptionsDeliveryModeHighQualityFormat: 只会返回一张高清图片
        1). PHImageRequestOptionsResizeModeNone: 如 1-a 一样
        2). PHImageRequestOptionsResizeModeFast: 如 1-b 一样
        3). PHImageRequestOptionsResizeModeExact: 如 1-c一样
 
    c. deliveryMode: PHImageRequestOptionsDeliveryModeFastFormat: 只会返回一张图片，并且可能是低清图
        1). PHImageRequestOptionsResizeModeNone: 返回一张低清图
        2). PHImageRequestOptionsResizeModeFast: 返回一张低清图
        3). PHImageRequestOptionsResizeModeExact: 返回一张低清图
 */

@implementation CATPhotoFetchConfig

- (instancetype)init {
    if (self = [super init]) {
        _mediaType = CATPhotoMediaTypeAll;
        _sortType = CATPhotoSortTypeNone;
    }
    return self;
}

@end









@implementation CATPhotoManager

+ (instancetype)shareManager {
    static CATPhotoManager *singleClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleClass = [[self alloc] init];
    });
    return singleClass;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static CATPhotoManager *singleClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleClass = [super allocWithZone:zone];//最先执行，只执行了一次
    });
    return singleClass;
}



- (void)fetchAlbumsWithAfterSmartAlbumUserLibraryHandler:(void (^)(NSArray<CATAlbum *> *))handler complete:(void (^)(NSArray<CATAlbum *> *))complete {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        
        NSMutableArray *localAlbums = [[NSMutableArray alloc] init];
        // 系统相机胶卷
        PHFetchResult<PHAssetCollection *> *fetchUserLibraryResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:options];
        [fetchUserLibraryResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
            
            @autoreleasepool {
                PHFetchResult<PHAsset *> *fetchAssetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (fetchAssetResult.count) {
                    CATAlbum *album = [[CATAlbum alloc] init];
                    album.collection = collection;
                    album.albumName = collection.localizedTitle;
                    album.assetCount = fetchAssetResult.count;
                    album.thumbAsset = [fetchAssetResult lastObject];
                    [localAlbums addObject:album];
                }
            }
        }];
        // 获取到本地相机胶卷后，返回出去，让外面做一些处理，如直接跳转至照片页面
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(localAlbums);
            }
        });
        // 其它智能相册
        PHFetchResult<PHAssetCollection *> *fetchRegularResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:options];
        [fetchRegularResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
            
            @autoreleasepool {
                if (collection.assetCollectionSubtype == PHAssetCollectionSubTypeRecentDelete) {
                    return;
                }
                PHFetchResult<PHAsset *> *fetchAssetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (fetchAssetResult.count) {
                    CATAlbum *album = [[CATAlbum alloc] init];
                    album.collection = collection;
                    album.albumName = collection.localizedTitle;
                    album.assetCount = fetchAssetResult.count;
                    album.thumbAsset = [fetchAssetResult lastObject];
                    [localAlbums addObject:album];
                }
            }
        }];
        
        // 用户创建的相册
        PHFetchResult<PHAssetCollection *> *fetchAlbumResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:options];
        [fetchAlbumResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
            
            @autoreleasepool {
                PHFetchResult<PHAsset *> *fetchAssetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (fetchAssetResult.count) {
                    CATAlbum *album = [[CATAlbum alloc] init];
                    album.collection = collection;
                    album.albumName = collection.localizedTitle;
                    album.assetCount = fetchAssetResult.count;
                    album.thumbAsset = [fetchAssetResult lastObject];
                    [localAlbums addObject:album];
                }
            }
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(localAlbums);
            }
        });
    });
    
}

- (void)fetchPhotosWithCollection:(PHAssetCollection *)colletion config:(CATPhotoFetchConfig *)config handler:(void(^)(NSArray<CATPhoto *> *photos))handler {
    
    if (config == nil) {
        config = [[CATPhotoFetchConfig alloc] init];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *localPhotos = [NSMutableArray array];
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        if (config.sortType == CATPhotoSortTypeAscending) {
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        } else if (config.sortType == CATPhotoSortTypeDescending) {
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        }
        if (config.mediaType == CATPhotoMediaTypePhoto) {
            options.predicate = [NSPredicate predicateWithFormat:@"(mediaType = %d)", PHAssetMediaTypeImage];
        } else if (config.mediaType == CATPhotoMediaTypeVideo) {
            options.predicate = [NSPredicate predicateWithFormat:@"(mediaType = %d)", PHAssetMediaTypeVideo];
        }
        
        PHFetchResult<PHAsset *> *fetchAssetResult = [PHAsset fetchAssetsInAssetCollection:colletion options:options];
        if (fetchAssetResult.count) {
            
            [fetchAssetResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
                @autoreleasepool {
                    
                    if (asset) {
                        CATPhoto *photo = [[CATPhoto alloc] init];
                        photo.asset = asset;
                        photo.localIdentifier = asset.localIdentifier;
                        [localPhotos addObject:photo];
                    }
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(localPhotos);
            }
        });
    });
    
}

- (void)requestAlbumThumbWithAlbum:(CATAlbum *)album targetSize:(CGSize)targetSize delegate:(id<CATPhotoDownLoadDelegate>)delegate {
    
    CGSize size = CGSizeZero;
    if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
        size = PHImageManagerMaximumSize;
    } else {
        targetSize = CGSizeMake(targetSize.width * [UIScreen mainScreen].scale, targetSize.height * [UIScreen mainScreen].scale);
        CGFloat aspectRatio = album.thumbAsset.pixelWidth / (CGFloat)album.thumbAsset.pixelHeight;
        if (targetSize.width > targetSize.height) {
            CGFloat pixelWidth = targetSize.width * [UIScreen mainScreen].scale;
            CGFloat pixelHeight = pixelWidth / aspectRatio;
            size = CGSizeMake(pixelWidth, pixelHeight);
        } else {
            CGFloat pixelHeight = targetSize.height * [UIScreen mainScreen].scale;
            CGFloat pixelWidth = pixelHeight * aspectRatio;
            size = CGSizeMake(pixelWidth, pixelHeight);
        }
    }
    NSLog(@"requestAlbumThumbWithAsset --- %@ --- identifier = %@", NSStringFromCGSize(size), album.thumbAsset.localIdentifier);
    
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.networkAccessAllowed = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:album.thumbAsset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"requestImageForAsset --- %@ --- identifier = %@", NSStringFromCGSize(result.size), album.thumbAsset.localIdentifier);
            if (delegate && [delegate respondsToSelector:@selector(photoManagerDownLoadSuccess:result:identifier:)]) {
                [delegate photoManagerDownLoadSuccess:self result:result identifier:album.thumbAsset.localIdentifier];
            }
        });
    }];
}


- (void)requestAssetImageWithPhoto:(CATPhoto *)photo targetSize:(CGSize)targetSize delegate:(id<CATPhotoDownLoadDelegate>)delegate {
    
    CGSize size = CGSizeZero;
    if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
        size = PHImageManagerMaximumSize;
    } else {
        CGFloat aspectRatio = photo.asset.pixelWidth / (CGFloat)photo.asset.pixelHeight;
        if (targetSize.width > targetSize.height) {
            CGFloat pixelWidth = targetSize.width * [UIScreen mainScreen].scale;
            CGFloat pixelHeight = pixelWidth / aspectRatio;
            size = CGSizeMake(pixelWidth, pixelHeight);
        } else {
            CGFloat pixelHeight = targetSize.height * [UIScreen mainScreen].scale;
            CGFloat pixelWidth = pixelHeight * aspectRatio;
            size = CGSizeMake(pixelWidth, pixelHeight);
        }
    }
    NSLog(@"requestAssetImageWithPhoto --- %@ --- identifier = %@", NSStringFromCGSize(size), photo.asset.localIdentifier);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.networkAccessAllowed = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:photo.asset targetSize:CGSizeMake(size.width * 1.5, size.height * 1.5) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"requestImageForAsset --- %@ --- identifier = %@", NSStringFromCGSize(result.size), photo.asset.localIdentifier);
            if (delegate && [delegate respondsToSelector:@selector(photoManagerDownLoadSuccess:result:identifier:)]) {
                [delegate photoManagerDownLoadSuccess:self result:result identifier:photo.localIdentifier];
            }
        });
    }];
}


@end












@implementation CATLibrary

+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        // 相册还未授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(status);
                }
            });
        }];
    } else {
        // 相册已经授权（可访问/不可访问）
        if (handler) {
            handler(status);
        }
    }
}

@end
