//
//  GraphingCalculatorAppDelegate.h
//  GraphingCalculator
//
//  Created by Gavin Hills on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphingCalculatorAppDelegate : NSObject <UIApplicationDelegate>

@property (readonly) BOOL iPad;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
