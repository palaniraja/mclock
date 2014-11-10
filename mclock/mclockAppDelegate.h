//
//  mclockAppDelegate.h
//  mclock
//
//  Created by Palaniraja on 12/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface mclockAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *__unsafe_unretained window;
}

@property (unsafe_unretained) IBOutlet NSWindow *window;

@end
