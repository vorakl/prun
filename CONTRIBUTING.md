Contribution Details
====================

All contributions are welcome and appreciated!


Prerequisites
-------------
There are just a few prerequisites for your contributions to be accepted:
 * Verification that you are really who you say you are. This is done
 by signing all git commits with the GnuPG key associated with the committer's
 email (`git commit -S ...`)
 * Sign of the [Developer Certificate of Origin](https://developercertificate.org/)
 to certify that you wrote the code, or otherwise have the right to submit
 the code. This is done by adding the `Signed-off-by` line to a commit message
 (`git commit -s ...`)
* One commit per Pull-Request, rebased on top of the main branch.
This is necessary to maintain a linear git history, and is usually done
by squashing commits (`git rebase -i`) into a single commit and force-pushing it
(`git push -f ...`) to your branch.


How to submit a change
----------------------
1. Fork the repository and define it as an `upstream` remote in your forked clone.
2. Create a branch and commit your change, using GnuPG signing and adding
`Signed-off-by` line to a commit message (`git commit -s -S`)
3. Push a new branch to the origin remote of your forked repository
4. Create a Pull-Request.


Useful links
------------
* [Developer Certificate of Origin versus Contributor License Agreements](https://julien.ponge.org/blog/developer-certificate-of-origin-versus-contributor-license-agreements/)
* [vim-cdo](https://github.com/zmc/dco.vim) plugin for manually adding
the `Signed-off-by` line when editing a commit message
