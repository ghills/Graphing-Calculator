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

- (void)viewDidLoad
{
    self.title = @"Calculator";
}

- (IBAction)decimalPointPressed:(UIButton *)sender
{    
    NSRange range = [display.text rangeOfString:@"."];
    if( range.location == NSNotFound )
    {
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
    
    if (userIsInTheMiddleOfTypingANumber) {
        display.text = [display.text stringByAppendingString:digit];
    } else {
        display.text = digit;
        userIsInTheMiddleOfTypingANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if ( userIsInTheMiddleOfTypingANumber ) {
        self.brain.operand = [display.text doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    NSString *operation = sender.titleLabel.text;
    double result = [self.brain performOperation:operation];
    if( [CalculatorBrain variablesInExpression:self.brain.expression] )
    {
        display.text = [CalculatorBrain descriptionOfExpression:self.brain.expression];
    } 
    else 
    {
        display.text = [NSString stringWithFormat:@"%g", result];
    }
}

- (IBAction)variablePressed:(UIButton *)sender
{
    if ( userIsInTheMiddleOfTypingANumber ) {
        self.brain.operand = [display.text doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    [self.brain setVariableAsOperand:sender.titleLabel.text];
    
    display.text = [CalculatorBrain descriptionOfExpression:self.brain.expression];
}

- (IBAction)graphPressed:(UIButton *)sender
{
    GraphViewController *graphController = [[GraphViewController alloc] init];
    graphController.expression = self.brain.expression;
    [self.navigationController pushViewController:graphController animated:YES];
    [graphController release];
}

- (void)dealloc
{
    [brain release];
    [super dealloc];
}

@end
