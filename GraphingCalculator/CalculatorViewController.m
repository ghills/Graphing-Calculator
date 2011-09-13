//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Gavin Hills on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "GraphViewController.h"

@interface CalculatorViewController()
@property (readonly) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

//NOTE: good lazy creation of objects - save memory
- (CalculatorBrain *)brain
{
    if(!brain) {
        brain = [[CalculatorBrain alloc] init];
    }
    return brain;
}

- (GraphViewController *)graphViewController
{
    if(!graphViewController)
    {
        graphViewController = [[GraphViewController alloc] init];
    }
    return graphViewController;
}

- (void)viewDidLoad
{
    self.title = @"Calculator";
}

- (IBAction)decimalPointPressed:(UIButton *)sender
{    
    NSRange range = [display.text rangeOfString:@"."];
    
    // Only add decimal point if no point exists already
    if( range.location == NSNotFound )
    {
        // No number in progress, so start with 0.
        if (!userIsInTheMiddleOfTypingANumber) {
            display.text = @"0.";
            userIsInTheMiddleOfTypingANumber = YES;
        } else {
            display.text = [display.text stringByAppendingString:@"."];
        }
    }
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    
    // Start new number or append to current number string
    if (userIsInTheMiddleOfTypingANumber) {
        display.text = [display.text stringByAppendingString:digit];
    } else {
        display.text = digit;
        userIsInTheMiddleOfTypingANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    // No longer entering a number if an operation button is pressed
    if ( userIsInTheMiddleOfTypingANumber ) {
        self.brain.operand = [display.text doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    
    NSString *operation = sender.titleLabel.text;
    double result = [self.brain performOperation:operation];
    
    if( [CalculatorBrain variablesInExpression:self.brain.expression] )
    {
        // if there are variables, get a textual description of the expression
        display.text = [CalculatorBrain descriptionOfExpression:self.brain.expression];
    } 
    else 
    {
        // no variables, just display the result from the brain
        display.text = [NSString stringWithFormat:@"%g", result];
    }
}

- (IBAction)variablePressed:(UIButton *)sender
{
    // while typing a number, consider the number finished
    if ( userIsInTheMiddleOfTypingANumber ) {
        self.brain.operand = [display.text doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    
    // add the variable to the operand list
    [self.brain setVariableAsOperand:sender.titleLabel.text];
    
    // now there is a variable in the expression, so get the description to display
    display.text = [CalculatorBrain descriptionOfExpression:self.brain.expression];
}

- (IBAction)graphPressed:(UIButton *)sender
{
    // set the model for the graph view (the expression to be evaluated)
    self.graphViewController.expression = self.brain.expression;
    
    if (!self.graphViewController.view.window)
    {
        [self.navigationController pushViewController:self.graphViewController animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (CGSize)contentSizeForViewInPopover
{
#define OUTER_MARGIN 10.0;
    
    CGRect unionRect = CGRectZero;
    
    for (UIView *v in self.view.subviews) {
        unionRect = CGRectUnion(unionRect, v.frame);
    }
    
    unionRect.size.width += OUTER_MARGIN;
    unionRect.size.height += OUTER_MARGIN;
    return unionRect.size;
}

- (void)dealloc
{
    [brain release];
    [graphViewController release];
    [super dealloc];
}

@end
