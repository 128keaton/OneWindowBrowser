//
//  NSCurvedButtonCell.h
//  OneWindowBrowser
//
//  Created by Keaton Burleson on 2/9/18.
//

#import <Cocoa/Cocoa.h>
#import "CTGradient.h"

@interface NSCurvedButtonCell : NSButtonCell
{
    CTGradient *pressedGradient;
    CTGradient *normalGradient;
    CGFloat radius;
    CGRect currentRect;
}
@end
