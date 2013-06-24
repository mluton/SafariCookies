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
        {@"remove",     'r',    DDGetoptNoArgument},
        {nil,           0,      0},
    };
    
    [optionsParser addOptionsFromTable: optionTable];
}

- (int) application:(DDCliApplication*)app runWithArguments:(NSArray*)arguments
{
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
