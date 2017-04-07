# calabash

A collection of scripts to make your life easier

## usage
```bash
#see a list of scripts
$ ./calabash.sh
#display help
$ ./calabash.sh --help
#display help of a script
$ ./calabash.sh -- <script to run>_--help"
#execute a script
$ ./calabash.sh -- <script to run>_[script arguments]"

#example 1: script with no arguments 
$ ./calabash.sh ip.sh

#example 2: script with arguments
$ ./calabash.sh -- configure-git.sh --name="John Doe" --email=john.d@example.com

#example 3: script help
$ ./calabash.sh -- configure-git.sh --help
```

## configuration
You can specify configurations for some of the scripts in the ./config directory. __DO NOT__ make changes in the .&ast;default.yml files. These files will be overwritten when you update unabashed. Use the &ast;.yml (config.yml for example) instead.

## unabashed
unabashed is a simple framework that helps with script development. It is available here <https://github.com/MetaphoricalSheep/unabashed>. The calabash repo currently includes a copy of unabashed, but this will change once update-unabashed is able to pull down the repo.
