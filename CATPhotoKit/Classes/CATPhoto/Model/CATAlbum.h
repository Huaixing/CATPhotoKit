//
//  CATAlbum.h
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/4.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

/**
 相册实例，描述某个相册信息，包括相册所含照片数量、缩略图、名称等
 */
@interface CATAlbum : NSObject
/**相册对应的photokit框架的相册类型PHAssetCollection，用于获取照片数据*/
@property (nonatomic, strong) PHAssetCollection *collection;
/**相册名称*/
@property (nonatomic, copy) NSString *albumName;
/**相册中文件数量*/
@property (nonatomic, assign) NSUInteger assetCount;

/**相册缩略图*/
@property (nonatomic, strong) UIImage *thumbImage;
/**相册缩略图thumbImage为空时，使用该asset下载缩略图*/
@property (nonatomic, strong) PHAsset *thumbAsset;
@end

