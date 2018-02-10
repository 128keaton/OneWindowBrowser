//
//  NSCurvedButton.h
//  OneWindowBrowser
//
//  Created by Keaton Burleson on 2/7/18.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface NSCurvedButton : NSButton {
    Class cellClass;
}

+ (Class)cellClass;

@end
