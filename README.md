# SafariCookies
A command line utility for OS X to display and optionally remove Safari cookies for a specified domain. Based on [RemoveCookie](https://github.com/robmathers/RemoveCookie) by [Rob Mathers](https://github.com/robmathers).

## Usage

Display cookies for domain.

    coookies example.com
    
Display cookies for domain and remove them. Short parameter version.

    cookies -r example.com
    
Display cookies for domain and remove them. Long parameter version.

    cookies --remove example.com

SafariCookies will search for all cookies whose domain ends in the argument you provide. So `cookies example.com` matches cookies for `example.com` and all subdomains of `example.com` (<i>i.e.</i> `blog.example.com, beta.example.com` and so on). Keep this in mind when using the `-r` switch to remove cookies. Removing cookies is fairly harmless. You may find you need to login to a site againor refill a shopping cart.

## Compatibility
This has been developed and tested on OS X 10.8.4 with Safari 6.0.5. It should work on OS X 10.6 and later but I haven't confirmed that. 

SafariCookies is provided as-is with no warranty or guarantee of any kind. You're free to use or modify it however you like for non-commercial use. If you come up with any useful or interesting modifications, feel free to submit a pull request.
