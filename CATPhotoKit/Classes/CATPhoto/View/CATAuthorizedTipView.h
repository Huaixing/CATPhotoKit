//
//  CATAuthorizedTipView.h
//  CATPhotoKit
//
//  Created by huaixing Shi on 2021/5/20.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, CATAuthorizedTipType) {
    CATAuthorizedTipNone,
    CATAuthorizedTipLimit,
};

typedef void(^CATHandleContinueLimitAction)(void);

@interface CATAuthorizedTipView : UIView

@property (nonatomic, copy) CATHandleContinueLimitAction handleAction;
- (instancetype)initWithAuthorizedType:(CATAuthorizedTipType)type;
@end

