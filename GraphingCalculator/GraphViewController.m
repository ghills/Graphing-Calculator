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

- (void)dealloc
{
    [expression release];
    [super dealloc];
}

@end
