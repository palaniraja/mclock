//
//  mclockAppDelegate.m
//  mclock
//
//  Created by Palaniraja on 12/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "mclockAppDelegate.h"

#import <ApplicationServices/ApplicationServices.h>
#include <IOKit/pwr_mgt/IOPMLib.h>

@implementation mclockAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    // Check that we have the Accessibility access we need; see https://stackoverflow.com/a/53617674/2752221
        if (!AXIsProcessTrusted()) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"Grant permission in Privacy & Security -> Accessibility"];
            [alert runModal];
            [NSApp terminate:nil];
        }

}



@end
