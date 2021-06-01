//
//  CATPhotoPickerController.h
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/6.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CATPhotoPickerController, CATPhoto;

/// 选择模式
typedef NS_ENUM(NSInteger, CATPickMode) {
    CATPickModeMultiplePick = 0,// 多选，但只针对照片类型
    CATPickModeSinglePick = 1,  // 单选
};

@protocol CATPhotoPickerControllerDelegate <NSObject>

@optional

/// 选择照片，点击完成，传给delegate，delegate需要执行dismiss
/// @param pickerController navi picker
/// @param selectedPhotos photos
- (void)photoPickerController:(CATPhotoPickerController *)pickerController didFinishPickPhotos:(NSArray<CATPhoto *> *)selectedPhotos;


/// 选择照片，点击预览，传给delegate，delegate需要执行dismiss
/// @param pickerController navi picker
/// @param selectedPhotos photos
- (void)photoPickerController:(CATPhotoPickerController *)pickerController didFinishPreviewPhotos:(NSArray<CATPhoto *> *)selectedPhotos;

@end

@interface CATPhotoPickerController : UINavigationController


/// picker delegate
@property (nonatomic, weak) id<CATPhotoPickerControllerDelegate> picker;

/// 照片列表中一行多少个，default 4
@property (nonatomic, assign) NSUInteger columns;
/// 照片列表中每两个照片之间的间距，default 1.0
@property (nonatomic, assign) CGFloat space;
/// 选择模式：单选/多选，多选只针对照片，默认多选
@property (nonatomic, assign) CATPickMode pickMode;
/// 勾选照片数量上限，default 9
/// 当pickmode为单选时，该设置无效
/// 当pickmode为多选，该设置为1时，则pickmode会自动置为单选
@property (nonatomic, assign) NSUInteger limitPhotoCount;

/// 自动进入所有照片相册，default YES
@property (nonatomic, assign) BOOL autoIntoLibrary;

@end
