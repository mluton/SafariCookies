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

@interface SafariCookies ()

@property (strong, nonatomic) NSHTTPCookieStorage *cookieStorage;
@property (strong, nonatomic) NSArray *matchedCookies;

@end

@implementation SafariCookies

- (void) application:(DDCliApplication*)app willParseOptions:(DDGetoptLongParser*)optionsParser;
{
    DDGetoptOption optionTable[] =
    {
        // Long             Short   Argument options
        {@"version",        'v',    DDGetoptNoArgument},
        {@"help",           'h',    DDGetoptNoArgument},
        {@"remove",         'r',    DDGetoptNoArgument},
        {@"all",            'a',    DDGetoptNoArgument},
        {@"exclude",        'e',    DDGetoptRequiredArgument},
        {@"exclude-file",   0,      DDGetoptRequiredArgument},
        {@"quiet",          'q',    DDGetoptNoArgument},
        {@"dry-run",        0,      DDGetoptNoArgument},
        {nil,               0,      0},
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
        ddprintf(@"  cookies example.com\t\t\t\t\tDisplay cookies for specified domain.\n");
        ddprintf(@"  cookies --remove example.com\t\t\tDisplay and remove cookies for specified domain.\n");
        ddprintf(@"  cookies --all\t\t\t\t\t\tMatch all cookies.\n");
        ddprintf(@"  cookies --exclude=example.com,asdf.com\tComma separated list of domains to exclude from matched cookies.\n");
        ddprintf(@"  cookies --exclude-file=domains.txt\t\tUse a file for the exclude list.\n");
        ddprintf(@"  cookies --remove example.com --dry-run\tMatch cookies but don't actually remove them.\n");
        return 0;
    }

    if ((arguments.count < 1) && (!_all)) {
        ddprintf(@"No Argument Given\n");
        return 1;
    }
    
    if (_excludeFile) {
        NSError *error = [[NSError alloc] init];
        NSString *fileContents = [NSString stringWithContentsOfFile:_excludeFile encoding:NSUTF8StringEncoding error:&error];
        
        if (error.code > 0) {
            NSLog(@"error: %@", error);
            return 1;
        }
        
        _exclude = [[fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@","];
    }


    self.cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    if (_all) {
        self.matchedCookies = [self filteredCookies:nil];
    }
    else {
        self.matchedCookies = [self filteredCookies:arguments[0]];
    }

    for (NSHTTPCookie *cookie in self.matchedCookies) {
        if (!_quiet) {
            ddprintf(@"----------------------------------------\n");
            ddprintf(@"domain: %@\n", cookie.domain);
            ddprintf(@"name: %@\n", cookie.name);
            ddprintf(@"path: %@\n", cookie.path);
            ddprintf(@"expires: %@\n", cookie.expiresDate);
            ddprintf(@"value: %@\n", cookie.value);
            ddprintf(@"----------------------------------------\n\n");
        }
        
        if (_remove && !_dryRun) {
            [self.cookieStorage deleteCookie:cookie];
        }
    }
    
    ddprintf(@"%li cookies%@\n", self.matchedCookies.count, _remove ? @" removed." : @"");
    
    if (_dryRun) {
        ddprintf(@"Dry run enabled. No cookies actually removed.\n");
    }

    return 0;
}

#pragma mark -

- (NSArray*) filteredCookies:(NSString*)argument
{
    NSPredicate *inclusivePredicate;
    
    if (argument) {
        inclusivePredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"domain ENDSWITH '%@'", argument]];
    }
    else {
        inclusivePredicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    }
    
    if (_exclude) {
        NSArray *excludedDomains = [_exclude componentsSeparatedByString:@","];
        NSMutableArray *excludedPredicates = [[NSMutableArray alloc] init];
        
        for (NSString *domain in excludedDomains) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"!(domain ENDSWITH '%@')", domain]];
            [excludedPredicates addObject:predicate];
        }

        NSPredicate *exclusivePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:excludedPredicates];
        NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[inclusivePredicate, exclusivePredicate]];
        return [self.cookieStorage.cookies filteredArrayUsingPredicate:compoundPredicate];
    }
    else {
        return [self.cookieStorage.cookies filteredArrayUsingPredicate:inclusivePredicate];
    }
}

@end
