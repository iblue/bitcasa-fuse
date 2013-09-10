What is this?
=============

This, ladies and gentlemen, is the unofficial bitcase linux client.
It's alpha and it will probably break. It may be illegal to use in some
countries and violates the terms of use of Bitcasa.

Heav phun.

Installation
============

* Install the fuse development headers (fuse-devel on fedora,
may vary on other distributions)
* Install RVM
* Install Ruby 2.0
* Run bundle install in this directory
* Create a file called "my-password.rb" where you specify

USERNAME = "your@email.com"
PASSWORD = "YourBitcasaPassword"
 
* ruby main.rb ./mointpoint

Implemented features
====================

- Directory listings
- Can read files (but only if they are small, because they will be
  cached in RAM)

Known Problems
==============

- Can not write files
- Will not pickup any changes from the server, unless you remount the
  bitcasa drive
- Because it uses the HTTP Frontend, it will probably never work for big
  files (larger than a few megabytes).

TODO
====

Reverse engineer the Windoze client. Implement the real bitcasa
protocol.
