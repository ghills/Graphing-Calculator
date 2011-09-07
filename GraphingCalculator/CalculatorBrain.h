//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Gavin Hills on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
{
@private
    double operand;
    NSString *waitingOperation;
    double waitingOperand;
    double memoryValue;
    id expression;
    NSMutableArray *internalExpression;
}

- (void)setOperand:(double)aDouble;
- (void)setVariableAsOperand:(NSString *)variableName;
- (double)performOperation:(NSString *)operation;

@property (readonly) id expression;

+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables;

+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;

+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

@end
