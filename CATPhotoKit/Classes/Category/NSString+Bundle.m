//
//  NSString+Bundle.m
//  CATPhotoKit
//
//  Created by Shihuaixing on 2020/9/16.
//

#import "NSString+Bundle.h"

@implementation NSString (Bundle)
+ (NSString *)localizationString:(NSString *)text {
    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"CATPhotoKit" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
    NSString *ret = [bundle localizedStringForKey:text value:@"" table:nil];
    return ret;
}
@end
