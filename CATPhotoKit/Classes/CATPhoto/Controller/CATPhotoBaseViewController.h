//
//  CATPhotoBaseViewController.h
//  CATPhotoKit
//
//  Created by huaixing Shi on 2021/5/13.
//

#import <UIKit/UIKit.h>
#import "CATPhotoNavigationBar.h"

@interface CATPhotoBaseViewController : UIViewController

@property (nonatomic, strong, readonly) CATPhotoNavigationBar *navigationBar;

/// 由于导航栏被隐藏了，且self.edgesForExtendedLayout = UIRectEdgeNone
/// 所以self.view的顶部布局是从屏幕顶部开始。
/// 如果底部有tabBar，则self.view会自动适配到tabbar顶部
/// 所以该frame的区域为，屏幕的顶部（不管有没有导航栏）到tabbar的顶部（有tabbar的时）；没有tabbar时，布局到屏幕底部
/// 只有在viewWillLayoutSubviews之后才能拿到正确的frame
- (CGRect)viewFrame;
/// 请在viewWillLayoutSubviews中布局完子视图后，将其置为YES。初始布局一次，防止后续处理子视图尺寸时，又执行了viewWillLayoutSubviews。
/// 默认：NO
@property (nonatomic, assign) BOOL layoutedSubviews;
@end

