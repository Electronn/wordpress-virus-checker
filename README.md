	WordPress Checker virus tool.

	Usage :

    --path                 : Shared path to your sites ( For example for /var/www/site1.com and /var/www/site2.com shared path - /var/www ). 
    --lang                 : Lagnuage of your WordPress copy. ( 'en' or 'ru' )
    --mode                 : Checker mode. Use blank for console output only. Use 'log' for simply logging. Use 'log-expert' for logging with diff on all of files.
                              Log for 'log' - /tmp/wordpress_checker/core.debug
                              Log for 'log-expert' - /tmp/wordpress_checker/core.log.expert
    --disable-check-plugin : Disable plugin dirs and files check
    --disable-check-upload : Disable upload dirs check for php files
    --disable-check-images : Disable all of images check for EXIF php injection

    Example : ./wpchecker.pl --path=/var/www --lang=en --mode=log-expert --disable-check-images

