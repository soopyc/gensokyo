# External Untracked Files

due to the required secure nature of these files, we are unable to include thses
sets of files/directories in this repository.

<!-- These are coincidentally the same length. magic! -->

- `-r-------- /etc/lego/desec`: acme credentials
- `drwx------ /var/lib/sbctl`: secure boot keys
- `-r-------- /v/l/forgejo/data/jwt/oauth.pem`: forgejo oauth jwt private key
- `-r-------- kita:/etc/radicale/users`: radicale user htpasswd mappings

## changelog

This section will only list removals.

### as of commit 8501880 (`850188052ea0968e7eb96724c2027ad998cbbefb`)

- ~~`nitter/guest_tokens.json`~~ managed in-tree
