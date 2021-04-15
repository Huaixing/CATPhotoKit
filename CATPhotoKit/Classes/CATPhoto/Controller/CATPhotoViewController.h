//
//  CATPhotoViewController.h
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/4.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CATAlbum;

@interface CATPhotoViewController : UIViewController

/**album*/
@property (nonatomic, strong) CATAlbum *album;
/// 是否支持多选（多选只针对照片）
@property (nonatomic, assign) BOOL canMultiplePick;

@end


