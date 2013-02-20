The Red Button
==============

The Red Button enables you to quickly put a series of web applications into maintenance mode.

This is probably most useful when dealing with a security event, such as the recent vulnerabilities in Rails and ActiveRecord. Unique Panic scripts can be created with different sets of targets depending on application type or version. You could have one Panic script for your Rails 2.3.x applications, one for your Rails 3.2.x applications, and one for your Wordpress blogs. The possibilities for shutting things down are endless!

Features
--------
* The Nginx configuration serves your maintenance page with a 503 status code. This prevents search engines from indexing the contents of the maintenance page and consequently harming your tireless SEO efforts, to the great dismay of upper management.
* Static asset requests are still allowed if the files exist, and these assets are served properly with a 200 status code. You can make your /maintenance.html page look beautiful using the magic of CSS and images.
* Maintenance pages can be configured so that they are persistent across deploys.
* Unlike most other Nginx maintenance configurations that you'll find online, it's not possible to bypass the maintenance page and hit the underlying application by requesting a nonexistent image or CSS file.
* Random David Caruso quotes from CSI: Miami are used as the confirmation phrases, and there's a pretty sweet ASCII sunglasses animation.

Requirements
------------
* Nginx configured with the proper rewrite rules
  * Support for Apache or other webservers is theoretically possible, but only Nginx configuration files are supplied at this time
* SSH access to the target servers
* Ruby 1.9.3

How it works
------------
Your Panic script simply instantiates a new Red Button with your chosen targets. When the "slam" method gets called, you will be prompted to type a confirmation phrase. Your list of targets is then processed in sequence and a maintenance file is placed in the configured directory of each host. Nginx looks for the presence of this file and serves the maintenance page when it exists. Finally, the URI for each target is checked to ensure that it is returning a 503 response code.

Setup
-----
1. Configure your Nginx vhosts using the files supplied in the nginx/ directory and reload your Nginx configuration.

    **Make sure the _maintenance.include file is placed at the end of each vhost to prevent conflicts with other rewrite rules.**

2. Make a maintenance.html page (if you don't already have one) and place it in your application's public/ folder.

3. Add a symlink in your application's public directory to the location where your Panic script will put the "maintenance-on" file for that target. Your shared/ directory is a good choice:

        ln -s /var/www/example.com/shared/maintenance-on /your/application/public/

   The Nginx rewrite rule only works if the symlink resolves to an actual file. Putting the maintenance-on file in shared/ means your maintenance page will remain up between deploys until the maintenance-on file is either deleted manually or using a Capistrano task.
   
   If you don't want this behavior, then you can skip this step and just configure public/ as the directory for your targets. Targets configured in this manner will not have persistent maintenance pages and will become active again when new code is deployed.

4. Modify the panic.rb script and add your targets.

5. Wait until it is time. Hopefully you'll never have to push The Red Button, but now you are ready to panic.

Acknowledgements
----------------
Thanks to [Trevor Smith](https://github.com/trevorsmith) for the original sunglasses animation.

License
-------
The MIT License (MIT)

Copyright (c) 2013 Joshua Lund

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
