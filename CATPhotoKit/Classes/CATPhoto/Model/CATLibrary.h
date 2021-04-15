//
//  CATLibrary.h
//  TestOCLint
//
//  Created by Shihuaixing on 2020/7/28.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

// 获取的文件类型
typedef NS_ENUM(NSInteger, CATPhotoFetchMediaType) {
    CATPhotoFetchMediaTypeAll = 0,// 照片和视频
    CATPhotoFetchMediaTypeImage = 1,// 照片
    CATPhotoFetchMediaTypeVideo = 2,// 视频
};

// 获取的文件排序类型<对asset.createData排序>
typedef NS_ENUM(NSInteger, CATPhotoFetchSortType) {
    CATPhotoFetchSortTypeNone = 0,// 按相册顺序
    CATPhotoFetchSortTypeAscending = 1,// 按createData升序
    CATPhotoFetchSortTypeDescending = 2,// 按createData降序
};

/// 请求完成的回调
typedef void (^CATCompleteHandler)(UIImage *result, NSString *identifier);

@class CATAlbum, CATPhoto, CATPhotoManager;



@interface CATPhotoFetchConfig : NSObject
/**media type*/
@property (nonatomic, assign) CATPhotoFetchMediaType mediaType;
@property (nonatomic, assign) CATPhotoFetchSortType sortType;

@end








@interface CATPhotoManager : NSObject

+ (instancetype)shareManager;

- (void)fetchAlbumsWithAfterSmartAlbumUserLibraryHandler:(void(^)(NSArray<CATAlbum *> *albums))handler complete:(void(^)(NSArray<CATAlbum *> *albums))complete;
- (void)fetchPhotosWithCollection:(PHAssetCollection *)colletion config:(CATPhotoFetchConfig *)config handler:(void(^)(NSArray<CATPhoto *> *photos))handler;

- (void)requestAlbumThumbWithAlbum:(CATAlbum *)album targetSize:(CGSize)targetSize complete:(CATCompleteHandler)complete;
- (void)requestAssetImageWithPhoto:(CATPhoto *)photo targetSize:(CGSize)targetSize complete:(CATCompleteHandler)complete;

@end






/**
 本地相册加载工具类，用于显示本地照片列表、保存照片/视频等对相册的查询和更新
 */
@interface CATLibrary : NSObject

+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler;

@end


