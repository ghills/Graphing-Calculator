//
//  GraphViewController.m
//  GraphingCalculator
//
//  Created by Gavin Hills on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@implementation GraphViewController

@synthesize graphView;
//@synthesize expression;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setExpression:(id)newExp
{
    [expression release];
    expression = [newExp copy];
    
    // set the view title to the expression
    self.title = [CalculatorBrain descriptionOfExpression:self.expression];
    
    [self.view setNeedsDisplay];
}

- (id)expression
{
    return expression;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // this controller will be the delegate for the graph view
    self.graphView.delegate = self;
    
    // reasonable initial scale factor
    self.graphView.scale = 10.0;
    
    // the title should be set by the expression - but set default
    self.title = @"Graph";
    
    [graphView setNeedsDisplay];
}

- (void)loadView
{
    GraphView *gv = [[GraphView alloc] initWithFrame:CGRectZero];
    gv.backgroundColor = [UIColor whiteColor];
    self.view = gv;
    self.graphView = gv;
    
    // make gesture listener
    UIGestureRecognizer *pinchgr = [[UIPinchGestureRecognizer alloc] initWithTarget:gv action:@selector(pinch:)];
    [gv addGestureRecognizer:pinchgr];
    [pinchgr release];
    
    //
    UIGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:gv action:@selector(pan:)];
    [gv addGestureRecognizer:pangr];
    [pangr release];
    
    //
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:gv action:@selector(tap:)];
    tapgr.numberOfTapsRequired = 2;
    [gv addGestureRecognizer:tapgr];
    [tapgr release];
}

- (double)solveForValue:(double)value
{
    // the dictionary will have only 1 item, "x" => x value
    NSDictionary *variableDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:value] forKey:@"x"];
    
    // evaluate the expression using the dictionary
    double result = [CalculatorBrain evaluateExpression:self.expression usingVariableValues:variableDictionary];
    
    return result;
}

- (IBAction)zoomInPressed:(UIButton *)sender
{
    // zoom in means more points per unit
    self.graphView.scale *= 2;
    [graphView setNeedsDisplay];
}

- (IBAction)zoomOutPressed:(UIButton *)sender
{
    // zoom out means less points per unit
    self.graphView.scale /= 2;
    [graphView setNeedsDisplay];
}

#pragma mark - UISplitViewControllerDelegate

// Called when a button should be added to a toolbar for a hidden view controller
- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma end

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)dealloc
{
    [expression release];
    [graphView release];
    [super dealloc];
}

@end
