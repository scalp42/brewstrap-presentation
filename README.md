# Brewstrap Presentation Example Repository

This is an example chef repository for use with brewstrap

# How this was created

    $ mkdir brewstrap-presentation
    $ cd brewstrap-presentation
    $ git init .
    $ mkdir -p cookbooks/brewstrap-presentation/recipes
    $ touch node.json
    $ git submodule add https://github.com/pivotal/pivotal_workstation.git cookbooks/pivotal_workstation
    $ git submodule add https://github.com/schubert/chef-osx.git cookbooks/osx
    
# History

#### 1.0.0 (master)

Initial concoction of recipes

# License

MIT licensed

Copyright (C) 2011 Michael Schubert, http://schubert.cx