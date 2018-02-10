//
//  NSButton+NSCurvedButton.m
//  OneWindowBrowser
//
//  Created by Keaton Burleson on 2/7/18.
//

#import <Foundation/Foundation.h>
#import "NSCurvedButton.h"
#import "NSCurvedButtonCell.h"

@implementation NSCurvedButton;

+ (Class)cellClass
{
    return [NSCurvedButtonCell class];
}
// cellClass

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (![aDecoder isKindOfClass:[NSKeyedUnarchiver class]])
        return [super initWithCoder:aDecoder];
    
    NSKeyedUnarchiver *unarchiver = (NSKeyedUnarchiver *)aDecoder;
    Class previousClass = [[self superclass] cellClass];
    Class newClass = [[self class] cellClass];
    
    [unarchiver setClass:newClass forClassName:NSStringFromClass(previousClass)];
    self = [super initWithCoder:aDecoder];
    [unarchiver setClass:previousClass forClassName:NSStringFromClass(previousClass)];
    
    return self;
}
// initWithCoder:

@end
