# Run the Perl script to select the site to restore from
perl /select-site.pl

# Get the environment variables that the Perl script printed for us
source /vars.sh

# Restore the WordPress files
bconsole << EOF
restore client=$HOST restoreclient=hub select current yes                      \
  strip_prefix=/var/www add_prefix=/tmp/bacula-restores
cd var/www/$FQDN
mark html/
done
EOF

# Prompt the user for the last JOBID for the client
echo "Enter the JOBID for the last run job in the list above"
read JOBID

# Restore the latest database backup using the last JOBID for the client
bconsole << EOF
restore client=$HOST restoreclient=hub jobid=$JOBID yes                        \
  strip_prefix=/tmp add_prefix=/tmp/bacula-restores/$FQDN
cd tmp/
mark $DB*
done
EOF
