//
//  GraphView.h
//  GraphingCalculator
//
//  Created by Gavin Hills on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDelegate
- (double)solveForValue:(double)value;
@end

@interface GraphView : UIView 
{
    id <GraphViewDelegate> delegate;
    CGFloat scale;
}

@property (assign) id <GraphViewDelegate> delegate;
@property (assign) CGFloat scale;

@end
