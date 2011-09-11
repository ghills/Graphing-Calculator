//
//  GraphView.m
//  GraphingCalculator
//
//  Created by Gavin Hills on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize delegate;
@synthesize scale;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

+ (BOOL)scaleIsValid:(CGFloat)aScale
{
    return ((aScale > 0) && (aScale <= 100));
}

#define DEFAULT_SCALE 5

- (CGFloat)scale
{
    return [GraphView scaleIsValid:scale] ? scale : DEFAULT_SCALE;
}

- (void)setScale:(CGFloat)newScale
{
    if([GraphView scaleIsValid:newScale])
    {
        if(newScale != scale) [self setNeedsDisplay];
        scale = newScale;
    }
}

- (CGPoint)getBoundsMidpoint
{
    return CGPointMake(self.bounds.origin.x + ( self.bounds.size.width / 2 ), self.bounds.origin.y + ( self.bounds.size.height / 2 ) );
}

- (CGPoint)origin
{
    return origin;
}

- (void)setOrigin:(CGPoint)newOrigin
{
    origin = newOrigin;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Axes should be blue
    [[UIColor blueColor] setStroke];
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    
    // calculate some values for drawing
    CGFloat pixelWidth = (self.bounds.size.width * [self contentScaleFactor]);
    
    // draw the path for the plotted data
    CGContextBeginPath(context);
    
    // draw the graph!
    for (int i = 0; i < pixelWidth; i++) 
    {
        // determine x value
        double xValue = ( ( i - (self.origin.x * [self contentScaleFactor] ) ) / [self contentScaleFactor] ) / self.scale;
        
        // solve for the y value from the x value
        double yValue = [self.delegate solveForValue:xValue];
        
        // determine y pixel
        CGFloat yPixel = ( self.origin.y * [self contentScaleFactor] ) + ( yValue * self.scale * [self contentScaleFactor]);
        
        // next point!
        CGPoint drawPt;
        drawPt.x = i / [self contentScaleFactor];
        drawPt.y = yPixel / [self contentScaleFactor];
        if( i == 0 )
        {
            CGContextMoveToPoint(context, drawPt.x, drawPt.y);
        } 
        else 
        {
            CGContextAddLineToPoint(context, drawPt.x, drawPt.y);
        }
    }
    
    // draw the plotted data path in red
    [[UIColor redColor] setStroke];
	CGContextDrawPath(context, kCGPathStroke);
    
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded) )
    {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded) )
    {
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if( gesture.state == UIGestureRecognizerStateEnded )
    {
        self.origin = [self getBoundsMidpoint];
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
