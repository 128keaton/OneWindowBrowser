//
//  NSCurvedButton.h
//  OneWindowBrowser
//
//  Created by Keaton Burleson on 2/7/18.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface NSCurvedButton : NSButton {
    NSBezierPath *path;
    float cornerRadius;
}

@property (strong) NSBezierPath *path;
@property (nonatomic) float cornerRadius;

- (NSBezierPath *)generateBezierPath:(NSRect)rect cornerRadius:(float)radius;


@end
