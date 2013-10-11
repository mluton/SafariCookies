//
//  SafariCookies.h
//  SafariCookies
//
//  Created by Michael Luton on 6/21/13.
//  Copyright (c) 2013 Sandmoose Software. All rights reserved.
//
//  Command line parsing with http://www.dribin.org/dave/software/ddcli/api/
//  Cookie manipulation code taken from https://github.com/robmathers/RemoveCookie
//

#import "DDCommandLineInterface.h"

@interface SafariCookies : NSObject <DDCliApplicationDelegate>
{
    // Create an instance variable for each command-line option specified in
    // application:willParseOptions. The instance variable name should be the
    // same as the long option name.
    BOOL _version;
    BOOL _help;
    BOOL _remove;
    BOOL _all;
    NSString *_exclude;
    NSString *_excludeFile;
    BOOL _quiet;
    BOOL _dryRun;
}

@end
