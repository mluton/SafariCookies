//
//  main.m
//  SafariCookies
//
//  Created by Michael Luton on 6/21/13.
//  Copyright (c) 2013 Sandmoose Software. All rights reserved.
//
//  Command line parsing with http://www.dribin.org/dave/software/ddcli/api/
//  Cookie manipulation code taken from https://github.com/robmathers/RemoveCookie
//

#import "DDCommandLineInterface.h"
#import "SafariCookies.h"

int main(int argc, const char * argv[])
{
    return DDCliAppRunWithClass([SafariCookies class]);
}

