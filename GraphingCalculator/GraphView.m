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

#define DEFAULT_SCALE 5

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    self.scale = DEFAULT_SCALE;
    self.origin = CGPointZero;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup]; 
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

+ (BOOL)scaleIsValid:(CGFloat)aScale
{
    return ((aScale > 0) && (aScale <= 100));
}

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

- (CGPoint)origin
{
    return origin;
}

- (void)setOrigin:(CGPoint)newOrigin
{
    origin = newOrigin;
    [self setNeedsDisplay];
}

- (CGPoint)getOriginInBounds
{
    return CGPointMake(self.bounds.origin.x + ( self.bounds.size.width / 2 ) + self.origin.x, self.bounds.origin.y + ( self.bounds.size.height / 2 ) + self.origin.y );
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint graphOrigin = [self getOriginInBounds];
    
    // Axes should be blue
    [[UIColor blueColor] setStroke];
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:graphOrigin scale:self.scale];
    
    // calculate some values for drawing
    CGFloat pixelWidth = (self.bounds.size.width * [self contentScaleFactor]);
    
    // draw the path for the plotted data
    CGContextBeginPath(context);
    
    // draw the graph!
    for (int i = 0; i < pixelWidth; i++) 
    {
        // determine x value
        double xValue = ( ( i - (graphOrigin.x * [self contentScaleFactor] ) ) / [self contentScaleFactor] ) / self.scale;
        
        // solve for the y value from the x value
        double yValue = [self.delegate solveForValue:xValue];
        
        // determine y pixel
        CGFloat yPixel = ( graphOrigin.y * [self contentScaleFactor] ) - ( yValue * self.scale * [self contentScaleFactor]);
        
        // next point!
        CGPoint drawPt = CGPointMake(i / [self contentScaleFactor], yPixel / [self contentScaleFactor]);
        if( i == 0 ) CGContextMoveToPoint(context, drawPt.x, drawPt.y);
        else CGContextAddLineToPoint(context, drawPt.x, drawPt.y);
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
        self.origin = CGPointZero;
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
