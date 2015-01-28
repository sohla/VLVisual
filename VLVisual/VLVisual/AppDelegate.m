//
//  AppDelegate.m
//  VLVisual
//
//  Created by Stephen OHara on 7/11/2014.
//  Copyright (c) 2014 Steph OHara. All rights reserved.
//

#import "AppDelegate.h"
#import "SOToolWindowController.h"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) SOToolWindowController *toolWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _toolWindowController = [[SOToolWindowController alloc] initWithWindowNibName:@"SOToolWindowController"];
    [self.toolWindowController showWindow:nil];
    


}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
