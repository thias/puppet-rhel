# We want umask to work well with ACLs
# It's perfectly safe to relax the group mode by default for users which have
# a private group (was the default until RHEL8, changed in RHEL9)
if [ $UID -gt 999 ] && [ "`/usr/bin/id -gn`" = "`/usr/bin/id -un`" ]; then
    umask 002
fi
