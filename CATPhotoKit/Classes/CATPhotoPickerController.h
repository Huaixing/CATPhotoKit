//
//  CATPhotoPickerController.h
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/6.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CATPhotoPickerController : UINavigationController

/**照片列表中一行多少个，default 4*/
@property (nonatomic, assign) NSUInteger columns;

/**照片列表中每两个照片之间的间距，default 1.0*/
@property (nonatomic, assign) CGFloat space;

@end
