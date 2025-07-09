Redmine Comments plugin
=======================

This plugin improves private notes in Redmine issues.
You can manage private notes visibility through roles and permissions.
A typical usage for a tech organization is to allow staff users to see/edit comments, but not lambda users.

The plugin requires Redmine version 2.5.0 or higher.

Private comments have been added in Redmine 2.2.0 and this plugin was originally made for Redmine < 2.1.0.
It now uses Redmine's default feature and old plugin's comments are automatically migrated to the standard Redmine feature.
See http://www.redmine.org/issues/1554 for more informations.

Screenshot
----------

![plugin screenshot](https://raw.githubusercontent.com/jbbarth/redmine_comments/master/assets/images/screenshot.png)

Test status
------------

|Plugin branch| Redmine Version | Test Status       |
|-------------|-----------------|-------------------|
|master       | 6.0.6           | [![6.0.6][1]][5]  |
|master       | 5.1.9           | [![5.1.9][2]][5]  |
|master       | master          | [![master][4]][5] |

[1]: https://github.com/jbbarth/redmine_comments/actions/workflows/6_0_6.yml/badge.svg
[2]: https://github.com/jbbarth/redmine_comments/actions/workflows/5_1_9.yml/badge.svg
[4]: https://github.com/jbbarth/redmine_comments/actions/workflows/master.yml/badge.svg
[5]: https://github.com/jbbarth/redmine_comments/actions
