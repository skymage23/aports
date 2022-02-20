IMPORTANT!
==========
This is a fork of the "aports" repository for Alpine Linux 3.15.0.
The main difference is it adds new profiles as well as a script
to export the generated ISOs to mounted, network-attached storage.

While the main profiles provided by the Alpine Linux project
should function as normal, always expect there to be differences
unless otherwise noted.  The ISOs generated with this fork
are generally for very specific uses of Alpine Linux.


Alpine Linux aports repository
==============================

This repository contains the APKBUILD files for each and every
Alpine Linux package, along with the required patches and scripts,
if any.

It also contains some extra files and directories related to testing
(and therefore, building) those packages on GitLab (via GitLab CI).

If you want to contribute, please read the
[contributor guide](https://wiki.alpinelinux.org/wiki/Alpine_Linux:Contribute)
and feel free to either submit a git patch on the Alpine aports
mailing list (~alpine/aports@lists.alpinelinux.org), or to submit a
merge request on [GitLab](https://gitlab.alpinelinux.org/alpine/aports).


Git Hooks
---------

You can find some useful git hooks in the `.githooks` directory.
To use them, run the following command after cloning this repository:

```sh
git config --local core.hooksPath .githooks
```
