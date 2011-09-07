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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Drawing code
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + ( self.bounds.size.width / 2 );
    midPoint.y = self.bounds.origin.y + ( self.bounds.size.height / 2 );
    
    float scaleFactor = self.scale;
    
    [[UIColor blueColor] setStroke];
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:scaleFactor];
    
    CGFloat pixelWidth = (self.bounds.size.width * [self contentScaleFactor]);
    CGFloat pixelHeight = (self.bounds.size.height * [self contentScaleFactor]);
    CGFloat minXVal = -midPoint.x / scaleFactor;
    CGFloat maxXVal = ( self.bounds.size.width - midPoint.x ) / scaleFactor;
    CGFloat minYVal = -( self.bounds.size.height - midPoint.y ) / scaleFactor;
    CGFloat maxYVal = midPoint.y / scaleFactor;
    
    //CGContextSetLineWidth(context,1.0);
    CGContextBeginPath(context);
    
    // draw the graph!
    for (int i = 0; i < pixelWidth; i++) 
    {
        // determine x value
        CGFloat perc = (i / pixelWidth);
        double xValue = ((maxXVal - minXVal) * perc) + minXVal;
        double yValue = [self.delegate solveForValue:xValue];
        
        // determine y pixel
        perc = yValue / ( maxYVal - minYVal );
        CGFloat yPixel = pixelHeight - ((midPoint.y * [self contentScaleFactor]) + (perc * pixelHeight));
        
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
    
    //CGContextDrawPath(context, kCGPathFillStroke);
    //CGContextStrokePath(context);
    [[UIColor redColor] setStroke];
	CGContextDrawPath(context, kCGPathStroke);
    
    
    // TEST DRAW BOX
    /*
    CGContextSetLineWidth(context,1.0);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddLineToPoint(context, 200, 100);
    CGContextAddLineToPoint(context, 200, 200);
    CGContextAddLineToPoint(context, 100, 200);
    
    CGContextStrokePath(context);
    */
    
}

- (void)dealloc {
    [super dealloc];
}

@end
