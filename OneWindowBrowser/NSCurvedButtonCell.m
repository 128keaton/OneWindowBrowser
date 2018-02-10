//
//  NSCurvedButtonCell.m
//  OneWindowBrowser
//
//  Created by Keaton Burleson on 2/9/18.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "NSCurvedButtonCell.h"
#import "NSBezierPathAdditions.h"
#import "CTGradient.h"

@implementation NSCurvedButtonCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    normalGradient = [[CTGradient gradientWithBeginningColor:[NSColor colorWithCalibratedWhite:.67 alpha:1.0] endingColor:[NSColor whiteColor]] retain];
    pressedGradient = [[CTGradient gradientWithBeginningColor:[NSColor colorWithCalibratedWhite:.506 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:.376 alpha:1.0]] retain];
    radius = 3.5;
    
    #if !MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_2
    // Manually draws bezel for 10.2
    [self drawBezelWithFrame: cellFrame inView: controlView];
    #endif
    [super drawWithFrame:cellFrame inView:controlView];
}
//drawWithFrame:

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    static NSColor *strokeColor = nil;
    static NSShadow *dropShadow = nil;
    static NSShadow *innerShadow1 = nil;
    static NSShadow *innerShadow2 = nil;
    
    currentRect = frame;
    
    if (dropShadow == nil){
        dropShadow = [self generateShadowWithColor:[NSColor colorWithCalibratedWhite:.863 alpha:.75]  offset:NSMakeSize(0, -1.0) blurRadius:1.0];
        innerShadow1 = [self generateShadowWithColor:[NSColor blackColor] offset:NSZeroSize blurRadius:3.0];
        innerShadow2 = [self generateShadowWithColor:[NSColor colorWithCalibratedWhite:0.0 alpha:.52] offset:NSMakeSize(0.0, -2.0) blurRadius:8.0];
        strokeColor = [[NSColor colorWithCalibratedWhite:.26 alpha:1.0] retain];
    }

    NSBezierPath *path = [self generateBezierPath:[self validateRect:currentRect] cornerRadius:radius];
    
    [NSGraphicsContext saveGraphicsState];
    [dropShadow set];
    [path fill];
    [NSGraphicsContext restoreGraphicsState];
    
    CTGradient *gradient = self.isHighlighted ? pressedGradient : normalGradient;
    [gradient fillBezierPath:path angle:-90];
    
    [strokeColor setStroke];
    [path strokeInside];
    
    if (self.isHighlighted) {
        [path fillWithInnerShadow:innerShadow1];
        [path fillWithInnerShadow:innerShadow2];
    }
}
// drawBezelWithFrame:


- (NSRect)validateRect:(NSRect)frame
{
    NSRect rect = frame;
    rect.size.height -= 1;
    rect.size.width -= 1;
    return rect;
}
// validateRect:

- (NSShadow *)generateShadowWithColor:(NSColor *)color offset:(NSSize)offset blurRadius:(CGFloat)blur
{
    NSShadow *dropShadow = [[NSShadow alloc] init];
    dropShadow.shadowColor = color;
    dropShadow.shadowOffset = offset;
    dropShadow.shadowBlurRadius = blur;
    
    return dropShadow;
}

// OS X 10.5+ has a built-in method to draw curved bezier paths. This is loosely based on that method.
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
// generateBezierPath:



@end
