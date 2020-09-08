//
//  UIImage+Bundle.m
//  CATPhotoKit
//
//  Created by Shihuaixing on 2020/9/8.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

+ (UIImage *)imageWithName:(NSString *)name {
    if (!name.length) {
        return nil;
    }
    NSString *bundlePath = [[NSBundle bundleForClass:NSClassFromString(@"CATPhotoKit")].resourcePath stringByAppendingPathComponent:@"/CATPhotoKit.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
