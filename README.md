# Tools - WordPress Restore

David Williamson @ Varilink Computing Ltd

------

This is a helper tool to facilitate the restoration of the files from the most recent backup of a WordPress site should you wish to use them for any purpose; for example to use them for working locally on a copy of the WordPress site on the user desktop, using the Varilink [Tools - WordPress](https://github.com/varilink/tools-wordpress) tool. It works in conjunction with the backup service implemented using the Varilink [Services - Ansible](https://github.com/varilink/services-ansible) repository and based on [Bacula](https://www.bacula.org/).

# Installation

This tool should be installed in the Ansible repository associated with a WordPress site project because it parses the Ansible variable files within such a repository to gather information that it requires. Install it by adding it the project's Ansible repository as a Git submodule at the path `tools/wordpress_restore`.

Since this tool is based on Docker Compose, you must concatenate the path to its `docker-compose.yml` file within the `COMPOSE_FILE` variable in the `.env` file for your project. This must come after the `docker-compose.yml` file for the project itself in the `COMPOSE_FILE` paths.

You must place the required `bconsole.conf` file within this tool's root folder in your project. Git is configured to ignore this file since it is specific to the configuration of your Bacula director and also contains sensitive data.

# Usage

Make sure that there is nothing in `/tmp/bacula-restores` on the *hub* host for the WordPress site that you're restoring from left over from a previous restore before you use this tool. This is to ensure that you don't end up with a merge of multiple restores in there. The simplest way is to remove the restored files each time immediately after you have used them.

You can then run the tool from within your project:

```sh
docker-compose run --rm wp-restore
```

The tool will prompt you twice for user inputs as follows:

1. To select the subdomain of the site that you want to restore from a list that the tool derives from the Ansible variables in `host_vars/` for your project.

2. To select the last JOBID from a list that the tool will output to ensure that you get the latest database backup taken for the site.

The tool submits restore jobs that will write the restored files to `/tmp/bacula-restores/$FQDN` on the *hub* host, where `$FQDN` corresponds to the WordPress site restored.
