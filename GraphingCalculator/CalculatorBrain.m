//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Gavin Hills on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

#define VARIABLE_PREFIX @"%"

@interface CalculatorBrain()
@property (readonly) NSMutableArray *internalExpression;
@end

@implementation CalculatorBrain

- (void)clearCalculator
{
    waitingOperation = nil;
    waitingOperand = 0;
    memoryValue = 0;
    operand = 0;
    [self.internalExpression removeAllObjects];
}

- (NSMutableArray *)internalExpression 
{
    if( !internalExpression )
    {
        internalExpression = [[NSMutableArray alloc] init];
    }
    return internalExpression;
}

- (id)expression
{
    NSArray *copyOfExpression = [self.internalExpression copy];
    [copyOfExpression autorelease];
    return copyOfExpression;
}

- (void)setOperand:(double)aDouble 
{
    operand = aDouble;
    [self.internalExpression addObject:[NSNumber numberWithDouble:operand]];
}

- (void)setVariableAsOperand:(NSString *)variableName 
{
    [self.internalExpression addObject:[VARIABLE_PREFIX stringByAppendingString:variableName]];
}

- (void)performWaitingOperation
{
    if( [@"+" isEqual:waitingOperation] )
    {
        operand = waitingOperand + operand;
    } else if( [@"-" isEqual:waitingOperation] )
    {
        operand = waitingOperand - operand;
    } else if( [@"*" isEqual:waitingOperation] )
    {
        operand = waitingOperand * operand;
    } else if( [@"/" isEqual:waitingOperation] )
    {
        if (operand) {
            operand = waitingOperand / operand;
        }
    }
}

- (double)performOperation:(NSString *)operation
{
    [self.internalExpression addObject:operation];
    
    if( [operation isEqual:@"sqrt"] ) {
        operand = sqrt(operand);
    } else if ( [operation isEqual:@"1/x"] ) {
        if( operand != 0 ) {
            operand = 1 / operand;
        }
    } else if ( [operation isEqual:@"+/-"] ) {
        operand = -1 * operand;
    } else if ( [operation isEqual:@"sin"] ) {
        operand = sin(operand);
    } else if ( [operation isEqual:@"cos"] ) {
        operand = cos(operand);
    } else if ( [operation isEqual:@"store"] ) {
        memoryValue = operand;
    } else if ( [operation isEqual:@"recall"] ) {
        operand = memoryValue;
    } else if ( [operation isEqual:@"mem+"] ) {
        memoryValue += operand;
    } else if ( [operation isEqual:@"C"] ) {
        [self clearCalculator];
    } else {
        [self performWaitingOperation];
        [waitingOperation release];
        waitingOperation = operation;
        [waitingOperation retain];
        waitingOperand = operand;
    }
    
    return operand;
}

+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables
{
    CalculatorBrain *brain = [[CalculatorBrain alloc] init];
    
    double resultingValue = 0.0;
    
    for( id expressionPiece in (NSArray *)anExpression )
    {
        if( [expressionPiece isKindOfClass:[NSNumber class]] )
        {
            NSNumber *expressionPieceNumber = (NSNumber *)expressionPiece;
            brain.operand = expressionPieceNumber.doubleValue;
        } else if ( [expressionPiece isKindOfClass:[NSString class]] )
        {
            NSString *expressionPieceString = (NSString *)expressionPiece;
            NSRange range = [expressionPieceString rangeOfString:VARIABLE_PREFIX];
            if ( range.location == 0 && expressionPieceString.length > 1 ) {
                // Starts with %, variable
                NSNumber *variableValue = (NSNumber *)[variables valueForKey:[expressionPieceString substringFromIndex:VARIABLE_PREFIX.length]];
                brain.operand = variableValue.doubleValue;
            } else {
                // Must be an operation
                resultingValue = [brain performOperation:expressionPieceString];
            }
        } else 
        {
            NSLog(@"Unrecognized type in expression array! %@", [expressionPiece type]);
        }
    }
    
    [brain release];
    
    return resultingValue;
}

+ (NSSet *)variablesInExpression:(id)anExpression
{
    NSArray *expressionArray;
    NSMutableSet *variableSet = [[NSMutableSet alloc] init];
    [variableSet autorelease];
    
    if( [anExpression isKindOfClass:[NSArray class]] )
    {
        expressionArray = (NSArray *)anExpression;
    }
    
    for (id expressionPiece in expressionArray) {
        if( [expressionPiece isKindOfClass:[NSString class]] )
        {
            NSString *expressionPieceString = (NSString *)expressionPiece;
            NSRange range = [expressionPieceString rangeOfString:VARIABLE_PREFIX];
            if ( range.location == 0 && expressionPieceString.length > 1 ) 
            {
                NSString *variable = [expressionPieceString substringFromIndex:VARIABLE_PREFIX.length];
                if (![variableSet member:variable]) 
                {
                    [variableSet addObject:variable];
                }
            }
        }
    }
    
    if ([variableSet count] == 0) {
        variableSet = nil;
    }
    
    return variableSet;
}

+ (NSString *)descriptionOfExpression:(id)anExpression
{
    NSMutableString *description = [[NSMutableString alloc] init];
    [description autorelease];
    NSArray *expressionArray;
    
    if( [anExpression isKindOfClass:[NSArray class]] )
    {
        expressionArray = (NSArray *)anExpression;
    }
    
    for (id expressionPiece in expressionArray) {
        
        // space before any pieces after the first
        if( description.length > 0 )
        {
            [description appendString:@" "];
        }
        
        if( [expressionPiece isKindOfClass:[NSNumber class]] )
        {
            NSNumber *expressionPieceNumber = (NSNumber *)expressionPiece;
            //[description appendString:[NSString stringWithFormat:@"%g", expressionPieceNumber]];
            [description appendFormat:@"%@", expressionPieceNumber];
            
        } else if ( [expressionPiece isKindOfClass:[NSString class]] )
        {
            NSString *expressionPieceString = (NSString *)expressionPiece;
            
            NSRange range = [expressionPieceString rangeOfString:VARIABLE_PREFIX];
            if ( range.location == 0 && expressionPieceString.length > 1 ) 
            {
                expressionPieceString = [expressionPieceString substringFromIndex:VARIABLE_PREFIX.length];
            }
            
            [description appendString:expressionPieceString];
        }
    }
    
    return description;
}

+ (id)propertyListForExpression:(id)anExpression
{
    NSArray *expressionArray;
    
    if( [anExpression isKindOfClass:[NSArray class]] )
    {
        expressionArray = (NSArray *)anExpression;
    }
    
    NSArray *expressionPropertyList = [expressionArray copy];
    [expressionPropertyList autorelease];
    return expressionPropertyList;
}

+ (id)expressionForPropertyList:(id)propertyList
{
    NSArray *expressionPropertyList;
    
    if( [propertyList isKindOfClass:[NSArray class]] )
    {
        expressionPropertyList = (NSArray *)propertyList;
    }
    
    NSArray *expressionArray = [expressionPropertyList copy];
    [expressionArray autorelease];
    return expressionArray;
}

- (void)dealloc
{
    [waitingOperation release];
    [internalExpression release];
    [super dealloc];
}

@end
