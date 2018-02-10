//
//  NSBezierPathAdditions.m
//  OneWindowBrowser
//
//  Created by Keaton Burleson on 2/9/18.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "NSBezierPathAdditions.h"

@implementation NSBezierPath (Additions)

// Credit for the next two methods goes to Matt Gemmell
- (void)strokeInside
{
    /* Stroke within path using no additional clipping rectangle. */
    [self strokeInsideWithinRect:NSZeroRect];
}

- (void)strokeInsideWithinRect:(NSRect)clipRect
{
    NSGraphicsContext *thisContext = [NSGraphicsContext currentContext];
    float lineWidth = [self lineWidth];
    
    /* Save the current graphics context. */
    [thisContext saveGraphicsState];
    
    /* Double the stroke width, since -stroke centers strokes on paths. */
    [self setLineWidth:(lineWidth * 2.0)];
    
    /* Clip drawing to this path; draw nothing outwith the path. */
    [self setClip];
    
    /* Further clip drawing to clipRect, usually the view's frame. */
    if (clipRect.size.width > 0.0 && clipRect.size.height > 0.0) {
        [NSBezierPath clipRect:clipRect];
    }
    
    /* Stroke the path. */
    [self stroke];
    
    /* Restore the previous graphics context. */
    [thisContext restoreGraphicsState];
    [self setLineWidth:lineWidth];
}

- (void)fillWithInnerShadow:(NSShadow *)shadow
{
    [NSGraphicsContext saveGraphicsState];
    
    NSSize offset = shadow.shadowOffset;
    NSSize originalOffset = offset;
    CGFloat radius = shadow.shadowBlurRadius;
    NSRect bounds = NSInsetRect(self.bounds, -(ABS(offset.width) + radius), -(ABS(offset.height) + radius));
    offset.height += bounds.size.height;
    shadow.shadowOffset = offset;
    NSAffineTransform *transform = [NSAffineTransform transform];
    if ([[NSGraphicsContext currentContext] isFlipped])
        [transform translateXBy:0 yBy:bounds.size.height];
    else
        [transform translateXBy:0 yBy:-bounds.size.height];
    
    NSBezierPath *drawingPath = [NSBezierPath bezierPathWithRect:bounds];
    [drawingPath setWindingRule:NSEvenOddWindingRule];
    [drawingPath appendBezierPath:self];
    [drawingPath transformUsingAffineTransform:transform];
    
    [self addClip];
    [shadow set];
    [[NSColor blackColor] set];
    [drawingPath fill];
    
    shadow.shadowOffset = originalOffset;
    
    [NSGraphicsContext restoreGraphicsState];
}

@end
