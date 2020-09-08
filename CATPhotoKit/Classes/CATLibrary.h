//
//  CATLibrary.h
//  TestOCLint
//
//  Created by Shihuaixing on 2020/7/28.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

// 文件类型
typedef NS_ENUM(NSInteger, CATPhotoMediaType) {
    CATPhotoMediaTypeAll = 0,// 照片和视频
    CATPhotoMediaTypePhoto = 1,// 照片
    CATPhotoMediaTypeVideo = 2,// 视频
};

// 文件排序类型<对asset.createData排序>
typedef NS_ENUM(NSInteger, CATPhotoSortType) {
    CATPhotoSortTypeNone = 0,// 按相册顺序
    CATPhotoSortTypeAscending = 1,// 按createData升序
    CATPhotoSortTypeDescending = 2,// 按createData降序
};

@class CATAlbum, CATPhoto, CATPhotoManager;


@protocol CATPhotoDownLoadDelegate <NSObject>

@optional
- (void)photoManagerDownLoadSuccess:(CATPhotoManager *)manager result:(UIImage *)result identifier:(NSString *)identifier;

@end







@interface CATPhotoFetchConfig : NSObject
/**media type*/
@property (nonatomic, assign) CATPhotoMediaType mediaType;
@property (nonatomic, assign) CATPhotoSortType sortType;

@end








@interface CATPhotoManager : NSObject

+ (instancetype)shareManager;

- (void)fetchAlbumsWithAfterSmartAlbumUserLibraryHandler:(void(^)(NSArray<CATAlbum *> *albums))handler complete:(void(^)(NSArray<CATAlbum *> *albums))complete;
- (void)fetchPhotosWithCollection:(PHAssetCollection *)colletion config:(CATPhotoFetchConfig *)config handler:(void(^)(NSArray<CATPhoto *> *photos))handler;

- (void)requestAlbumThumbWithAlbum:(CATAlbum *)album targetSize:(CGSize)targetSize delegate:(id<CATPhotoDownLoadDelegate>)delegate;
- (void)requestAssetImageWithPhoto:(CATPhoto *)photo targetSize:(CGSize)targetSize delegate:(id<CATPhotoDownLoadDelegate>)delegate;

@end






/**
 本地相册加载工具类，用于显示本地照片列表、保存照片/视频等对相册的查询和更新
 */
@interface CATLibrary : NSObject

+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler;

@end


