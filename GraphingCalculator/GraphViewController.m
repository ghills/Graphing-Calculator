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
    //NSArray *myExp = [[NSArray alloc] initWithArray:newExp copyItems:YES];
    expression = newExp;
    expression = [newExp copy];
    
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
    self.graphView.delegate = self;
    self.graphView.scale = 10.0;
    self.title = @"Graph";
    
    [graphView setNeedsDisplay];
}

- (double)solveForValue:(double)value
{
    NSDictionary *variableDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:value] forKey:@"x"];
    
    double result = [CalculatorBrain evaluateExpression:self.expression usingVariableValues:variableDictionary];
    
    return result;
}

- (IBAction)zoomInPressed:(UIButton *)sender
{
    self.graphView.scale *= 2;
    [graphView setNeedsDisplay];
}

- (IBAction)zoomOutPressed:(UIButton *)sender
{
    self.graphView.scale /= 2;
    [graphView setNeedsDisplay];
}

- (void)dealloc
{
    //
    [expression release];
    [super dealloc];
}

@end
