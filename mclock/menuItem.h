//
//  menuItem.h
//  mclock
//
//  Created by Palaniraja on 12/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface menuItem : NSObject {
@private
    NSStatusItem *statusItem;
    
    NSDateFormatter *formatter;
    
    NSTimer *updateTimer;
    
    NSString *zone;
}

-(void) updateLabel:(id)sender;

@end
