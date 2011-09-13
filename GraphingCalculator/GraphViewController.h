//
//  GraphViewController.h
//  GraphingCalculator
//
//  Created by Gavin Hills on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController <GraphViewDelegate, UISplitViewControllerDelegate>
{
    GraphView *graphView;
    id expression;
}

@property (retain) IBOutlet GraphView *graphView;
@property (copy) id expression;

- (IBAction)zoomInPressed:(UIButton *)sender;
- (IBAction)zoomOutPressed:(UIButton *)sender;

@end
