# external files not tracked by flakes

due to the required secure nature of these files, we are unable to include
thses sets of files/directories in this repository.

<!-- These are coincidentally the same length. magic! -->
- `-rw------- /etc/atticd.env`: attic credentials file
- `-r-------- /etc/lego/desec`: acme credentials
- `drwx------ /etc/secureboot`: secureboot keys

## changelog
### as of commit 8501880 (`850188052ea0968e7eb96724c2027ad998cbbefb`)
- `nitter/guest_tokens.json` managed in-tree
