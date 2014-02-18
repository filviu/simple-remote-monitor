simple-remote-monitor
=====================

Simple remote monitor script that I use when a full blown sollution like nagios is not required. For example I use it on a remote collocated Raspberry Pi to monitor a few hosts.


usage
=====

it's still rather rough, but in a few words:
- install it somewhere
- edit srm.sh (second line) to set the location of the config file
- edit the .srm-config file (email, target, state file etc)
- create the state file (copy the one supplied here)
- add the script in crontab (I run it every 5 minutes, this means 10-15 minutes of downtime before I get a report)

Multiple hosts
==============
- install multiple instances with different state files
- or adjust the code and use arrays for hosts, names and statefiles (it should be an easy update)

I didn't add any because if I need more than 1-2 hosts monitored I use nagios not this
