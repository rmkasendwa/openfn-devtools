#!/bin/bash

# Demo sample_script.sh tests

testBaseInstallScript() {
  echo "Test initial setup script..."

  . install.sh

  assertTrue 'Check default that core has been installed:' "[ -d core ] && [ -d core/node_modules ]"
  assertTrue 'Check default that language-common has been installed:' "[ -d language-common ] && [ -d language-common/node_modules ]"
}

testAdaptorInstallScript(){
  echo "Test language-package installation..."

  . install.sh language-salesforce

  assertTrue 'Check default that language-http has been installed:' "[ -d language-salesforce ] && [ -d language-salesforce/node_modules ]"
}

. shunit2-2.1.6/src/shunit2