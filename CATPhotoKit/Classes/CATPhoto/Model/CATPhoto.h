//
//  CATPhoto.h
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/4.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


// 文件类型
typedef NS_ENUM(NSInteger, CATPhotoMediaType) {
    CATPhotoMediaTypeUnkown = 1,// unkown
    CATPhotoMediaTypeImage = 1,// 照片
    CATPhotoMediaTypeVideo = 2,// 视频
};

@interface CATPhoto : NSObject

/**phasset*/
@property (nonatomic, strong) PHAsset *asset;
/// media type
@property (nonatomic, assign) CATPhotoMediaType mediaType;

/**identifier*/
@property (nonatomic, copy) NSString *localIdentifier;

/**icloud*/
@property (nonatomic, assign, getter = isiCloud) BOOL iCloud;

/// selected
@property (nonatomic, assign, getter = isSelected) BOOL selected;

@end

