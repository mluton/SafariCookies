# SafariCookies
A command line utility for OS X to display and optionally remove Safari cookies for a specified domain. Based on [RemoveCookie](https://github.com/robmathers/RemoveCookie) by [Rob Mathers](https://github.com/robmathers).

## Download
OS X executable. Requires OS X 10.6 or later. Unzip and place somewhere in your **PATH**.

[cookies.zip](http://sourceforge.net/projects/mlsafaricookies/files/cookies.zip/download)

## Usage

Display cookies for domain.

    coookies example.com
    
Display cookies for domain and remove them.

    cookies --remove example.com
    
Display all cookies

    cookies --all
    
 Exclude cookies from specified domains from list of matched cookies. Multiple domains can be specified separated by commas.
 
     cookies --all --exclude=example1.com,example2.com

Use a file for the exclusion list. This example will remove all cookies except for those in a list of trusted domains in the `good_domains.txt` file.

    cookies --all --remove --exclude-file=/Users/michael/good_domains.txt

If you want to test what the command would do without actually doing it use the `--dry-run` option. Most useful with the `--remove` option.

    cookies --all --remove --exclude=aws.amazon.com --dry-run
    
If you don't want the verbose output then use the `--quiet` option. Useful if you're using this in a cron job and don't want to fill up your logs with a bunch of extra information.

    cookies --all --remove --quiet

SafariCookies will search for all cookies whose domain ends in the argument you provide. So `cookies example.com` matches cookies for `example.com` and all subdomains of `example.com` (<i>i.e.</i> `blog.example.com, beta.example.com` and so on). Keep this in mind when using the `--remove` switch to remove cookies. Removing cookies is fairly harmless though. You may find you need to login to a site again or refill a shopping cart.

## Compatibility
This has been developed and tested on OS X 10.8.5 with Safari 6.0.5 and Xcode 5. It should work on OS X 10.6 and later but I haven't confirmed that. 

SafariCookies is provided as-is with no warranty or guarantee of any kind. You're free to use or modify it however you like for non-commercial use. If you come up with any useful or interesting modifications, feel free to submit a pull request.
