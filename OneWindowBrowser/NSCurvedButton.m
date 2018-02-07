//
//  NSButton+NSCurvedButton.m
//  OneWindowBrowser
//
//  Created by Keaton Burleson on 2/7/18.
//

#import <Foundation/Foundation.h>
#import "NSCurvedButton.h"

@implementation NSCurvedButton;

@synthesize path, cornerRadius;

- (void)drawRect:(NSRect)dirtyRect {
    
    if (![self cornerRadius]){
        self.cornerRadius = 5.0f;
    }
    
    NSRect validRect = [self validRect:dirtyRect];

    self.path = [self generateBezierPath:validRect cornerRadius:[self cornerRadius]];
    
    // Sets fill color to the NSButton background color
    [self setWantsLayer:YES];
    [[NSColor whiteColor] setFill];
    [path fill];
    
    if (![[self title]  isEqual: @""]){
        [self drawTitle:[self title]];
    }
    if ([self image] != nil){
        [self drawImage:[self image] rect:validRect];
    }
    
}
// drawRect:

- (NSRect)validRect:(NSRect)dirtyRect {
    dirtyRect.size.height = 24;
    dirtyRect.origin.y = dirtyRect.origin.y + 1;
    return dirtyRect;
}

- (void) drawTitle:(NSString *)title{
    
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSColor grayColor], NSForegroundColorAttributeName,
                                    [self font], NSFontAttributeName,
                                    nil];
    
    NSRect rect;
    rect.size = [title sizeWithAttributes:attributesDict];
    rect.origin.x = roundf( NSMidX([self bounds]) - rect.size.width / 2 );
    rect.origin.y = roundf( NSMidY([self bounds]) - rect.size.height / 4 );
    
    [title drawInRect:rect withAttributes:nil];
}
// drawTitle:

- (void) drawImage:(NSImage *)image rect:(NSRect) rect{
    [image drawInRect:rect];
}

// drawTitle:

- (NSBezierPath *)generateBezierPath:(NSRect)dirtyRect cornerRadius:(float)radius {
    NSBezierPath *generatedPath = [NSBezierPath bezierPath];
    if (!NSIsEmptyRect(dirtyRect)) {
        if (radius > 0.0) {
            // Clamp radius to be no larger than half the rect's width or height.
            float clampedRadius = MIN(radius, 0.5 * MIN(dirtyRect.size.width, dirtyRect.size.height));
            
            float maxY = NSMaxY(dirtyRect);
            float minY = NSMinY(dirtyRect);
            NSPoint origin = NSMakePoint(dirtyRect.origin.x, dirtyRect.origin.y);
            
            NSPoint topLeft = NSMakePoint(NSMinX(dirtyRect), maxY);
            NSPoint topRight = NSMakePoint(NSMaxX(dirtyRect), maxY);
            NSPoint bottomRight = NSMakePoint(NSMaxX(dirtyRect), minY);
            
            [generatedPath moveToPoint:NSMakePoint(NSMidX(dirtyRect), maxY)];
            
            [generatedPath appendBezierPathWithArcFromPoint:topLeft     toPoint:origin radius:clampedRadius];
            [generatedPath appendBezierPathWithArcFromPoint:origin toPoint:bottomRight radius:clampedRadius];
            [generatedPath appendBezierPathWithArcFromPoint:bottomRight toPoint:topRight    radius:clampedRadius];
            [generatedPath appendBezierPathWithArcFromPoint:topRight    toPoint:topLeft     radius:clampedRadius];
            [generatedPath closePath];
            return generatedPath;
        } else {
            // When radius == 0.0, this degenerates to the simple case of a plain rectangle.
            [generatedPath appendBezierPathWithRect:dirtyRect];
            return generatedPath;
        }
    }
}




@end
