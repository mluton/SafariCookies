//
//  SafariCookies.m
//  SafariCookies
//
//  Created by Michael Luton on 6/21/13.
//  Copyright (c) 2013 Sandmoose Software. All rights reserved.
//
//  Command line parsing with http://www.dribin.org/dave/software/ddcli/api/
//  Cookie manipulation code taken from https://github.com/robmathers/RemoveCookie
//

#import "SafariCookies.h"

@implementation SafariCookies

- (void) application:(DDCliApplication*)app willParseOptions:(DDGetoptLongParser*)optionsParser;
{
    DDGetoptOption optionTable[] =
    {
        // Long         Short   Argument options
        {@"version",    'v',    DDGetoptNoArgument},
        {@"help",       'h',    DDGetoptNoArgument},
        {@"remove",     'r',    DDGetoptNoArgument},
        {nil,           0,      0},
    };
    
    [optionsParser addOptionsFromTable: optionTable];
}

- (int) application:(DDCliApplication*)app runWithArguments:(NSArray*)arguments
{
    if (_version) {
        ddprintf(@"cookies 1.0\n");
        return 0;
    }
    
    if (_help) {
        ddprintf(@"usage:\n");
        ddprintf(@"  cookies example.com\t\tDisplay cookies for specified domain.\n");
        ddprintf(@"  cookies -r example.com\tDisplay and remove cookies for specified domain.\n");
        return 0;
    }

    if (arguments.count < 1) {
        ddprintf(@"No Argument Given\n");
        return 1;
    }

    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSString *filterString = [[NSString alloc] initWithFormat:@"domain ENDSWITH '%@'", arguments[0]];
    NSPredicate *filter = [NSPredicate predicateWithFormat:filterString];
    NSArray *matchedCookies = [cookieStorage.cookies filteredArrayUsingPredicate:filter];
    
    for (NSHTTPCookie *cookie in matchedCookies) {
        ddprintf(@"----------------------------------------\n");
        ddprintf(@"domain: %@\n", cookie.domain);
        ddprintf(@"name: %@\n", cookie.name);
        ddprintf(@"path: %@\n", cookie.path);
        ddprintf(@"expires: %@\n", cookie.expiresDate);
        ddprintf(@"value: %@\n", cookie.value);
        ddprintf(@"----------------------------------------\n\n");
        
        if (_remove) {
            [cookieStorage deleteCookie:cookie];
        }
    }
    
    ddprintf(@"%li cookies%@\n", matchedCookies.count, _remove ? @" removed." : @"");
    return 0;
}

@end
