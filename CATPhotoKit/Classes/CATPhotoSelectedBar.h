//
//  CATPhotoSelectedBar.h
//  CATPhotoKit
//
//  Created by Shihuaixing on 2020/9/8.
//

#import <UIKit/UIKit.h>

@interface CATPhotoSelectedBar : UIView

/// selected count
@property (nonatomic, assign) NSInteger count;
/// 选择栏底部留白，刘海屏适配
- (CGFloat)bottomMargin;

@end


