#!/bin/sh

# Hook to run after mbsync downloads all the emails. This hook specifies the
# rules to tag the mails. This is basically where you specify your "email
# filters". Each line is just a bash command. You can find out more about syntax
# and features with 'man notmuch'.

# Later you can use these tags in neomutt configuration to create virtual
# mailboxes (virtual-mailbox command).

# I store this script in ~/.local/bin which in my $PATH.

# Tag all emails as new
notmuch new
# retag all "new" messages "inbox" and "unread"
notmuch tag +inbox +unread -new -- tag:new
# tag all messages from "me" as sent and remove tags inbox and unread
notmuch tag -new -unread +sent -- from:andrey.albershteyn@gmail.com
# tag newsletters, but dont show them in inbox
notmuch tag +newsletters -inbox -new -- subject:'newsletter*'
# Tag emails from cron
notmuch tag +cron -inbox -new -- subject:'Cron*'
# Tag emails from gitlab
notmuch tag +gitlab -inbox -new -- from:*@gitlab.com
