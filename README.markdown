* **Author**: [Wael Nasreddine][]
* **Source Code**: [Github][]

## Synopsis

AutosyncML is a script to synchronize mainling lists against a database

## Description

We, The [AULF][] webmasters, wanted to minimize our efforts by creating a robot
to update the mailing lists subscriptions, which I'll detail in the next
section, so I wrote this script to do exactly what we wanted.

## Problem

On the website of the [AULF][], students can open an account and become members
of the AULF, send and receive emails from/to the people in the same department
as they are in, or studying the same major as they are etc.. We used to
subscribe and un-subscribe manually each update / new addition which become an
endless job after a while, so we needed to automatize this process, and
autosyncml was the best solution.

## Solution

AutosyncML acts as a proxy between mysql and mailman, it can communicate with both of them and here's how it works:

* Get a list of all available mailing lists
* Get a list of all available subscribed members to the available mailing lists
* Get a list of all available members in the database and for each member:
	* Check if the email has changed by comparing it against a second copy (made by a previous run)
	* If the email has changed, the old email will be un-subscribed from all mailing lists, the new email will be subscribed.
	* Get a list of all already subscribed mailing lists
	* Get a list of all mailing lists that this email should be subscribed to
	* un-subscribe him from lists he's subscribed to but shouldn't be subscribe to
	* Finally, subscribe him to the lists he should be subscribed to but not already subscribed to
* Send the log to the defined email in the settings.

## Installation

To install, you first need a copy of the code, so check it out

	git clone git://github.com/eMxyzptlk/autosyncml.git

Go inside the autosyncml folder and run make / make install

	make prefix=/usr
	sudo make prefix=/usr install

Edit the settings file

	vim /etc/autosyncml.ini

Setup a cronjob, to run (every 30 minutes if no control file, every minute with a control file):

Every 30 minutes:

	*/30 * * * * export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin; /usr/bin/autosyncml

Every minute:

	*/1 * * * * export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin; /usr/bin/autosyncml

To report bugs or ask for new features, please use the Tickets tab on the project [page][]

[Wael Nasreddine]: http://wael.nasreddine.com
[Github]: http://github.com/eMxyzptlk/autosyncml
[AULF]: http://www.aulf.org
[page]: http://wael.nasreddine.com/projects/autosyncml.html
