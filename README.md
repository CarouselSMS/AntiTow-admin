AntiTow Admin
=============

### Basic admin app for AntiTow.com street sweeping alerts.


Pulls in a calendar (iCal) from a public address, parses the feed to schedule reminders and to fill in the reminder body.

Reminders are sent to SMS subscribers at the offsets specified in the UI. Say, 24 for a full day, or 1 for an hour.

Add multiple offsets, and subsequently, multiple reminders, by separating them with commas.

#### Notes:

* API keys and passwords redacted, but otherwise, everything is there. Basic HTTP auth. Well, basic everything :)
* It's a Rails 2.3.2 app, created and operated since that was the latest and greatest. Continues to work with our SMS API ([CarouselSMS](http://carouselsms.com)).

#### Screenshots:

_Locations_

[![main screen](http://dl.dropbox.com/u/225019/rm-app-screenshots/AntiTow-admin/thumbs/thumb_AntiTow-main.png)](http://dl.dropbox.com/u/225019/rm-app-screenshots/AntiTow-admin/AntiTow-main.png)
[![location edit](http://dl.dropbox.com/u/225019/rm-app-screenshots/AntiTow-admin/thumbs/thumb_AntiTow-location-edit.png)](http://dl.dropbox.com/u/225019/rm-app-screenshots/AntiTow-admin/AntiTow-location-edit.png)

_Groups_

[![groups](http://dl.dropbox.com/u/225019/rm-app-screenshots/AntiTow-admin/thumbs/thumb_AntiTow-groups.png)](http://dl.dropbox.com/u/225019/rm-app-screenshots/AntiTow-admin/AntiTow-groups.png)
[![groups edit](http://dl.dropbox.com/u/225019/rm-app-screenshots/AntiTow-admin/thumbs/thumb_AntiTow-groups-edit.png)](http://dl.dropbox.com/u/225019/rm-app-screenshots/AntiTow-admin/AntiTow-groups-edit.png)

License
=======

AntiTow is Copyright © 2013 [Recess Mobile](http://recess.im/).

It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
