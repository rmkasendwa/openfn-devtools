# OpenFn Devtools [![Build Status](https://travis-ci.org/OpenFn/openfn-devtools.svg?branch=master)](https://travis-ci.org/OpenFn/openfn-devtools)
A set of tools for writing &amp; testing expressions, managing OpenFn projects, and developing new adaptors (language-packages).

## Pre-Requisites
[Git](https://git-scm.com/downloads) (Use GitBash for Windows.)  
[Node.js](https://nodejs.org/en/download/) (Version 6.11 or greater.)

## Basic offline job-runner usage
You can run core from anywhere by using `npm install -g` for global install:  
`npm install -g github:openfn/core#v1.0.0`

## Installation
```sh
git clone https://github.com/OpenFn/openfn-devtools.git  
cd openfn-devtools
./install.sh
```
If you get a "permission denied" message when running `./install.sh`, run `run chmod +x ./install.sh ` then retry the install command.

## Install language-packages
```sh
./install.sh language-${name}
```

## Usage
Execute takes:
1. `-l [language-package].Adaptor`: The language-package.
2. `-e [expression.js]:` The expression being tested.
3. `-s [state.json]`: The message `data: {...}` and credential `configuration: {...}`.
4. `-o [output.json]`: The file to which the output will be written.

### Bash usage
`./core/lib/cli.js execute -l ./language-[XXX].Adaptor -s ./tmp/state.json -o ./tmp/output.json -e ./tmp/expression.js`

### The `--test` option
`./core/lib/cli.js execute -l ./language-[XXX].Adaptor -s ./tmp/state.json -o ./tmp/output.json -e ./tmp/expression.js --test`  
This intercepts all HTTP requests and displays the request information for debugging.

#### `.FakeAdaptor`
`language-salesforce` has a built-in `.FakeAdaptor` which allows a user to test expressions on data without sending them to a real Salesforce server.  
Instead of using `-l ./language-salesforce.Adaptor`, use `-l./language-salesforce.FakeAdaptor` to test expressions offline:
`./core/lib/cli.js execute -l ./language-salesforce.FakeAdaptor -s ./tmp/state.json -o ./tmp/output.json -e ./tmp/expression.js`

#### Offline testing for other `language-packages`
For most standard language packages, it's fairly easy to remove the HTTP post calls from the top-level function.

###### Here's how to make the `event()` function for `language-dhis2` work offline:  
`cd language-dhis2` edit `src/Adaptor.js` using `vim` or your favorite text editor  
comment out the `post().then()` from line 67-78:
```js
export function event(eventData) {

  return state => {
    const body = expandReferences(eventData)(state);

    const {
      username,
      password,
      apiUrl
    } = state.configuration;

    const url = resolveUrl(apiUrl + '/', 'api/events')

    console.log("Posting event:");
    console.log(body)

    // Commented out post().then() for offline testing.
    // return post({
    //     username,
    //     password,
    //     body,
    //     url
    //   })
    //   .then((result) => {
    //     console.log("Success:", result);
    //     return {...state,
    //       references: [result, ...state.references]
    //     }
    //   })

  }
}
```
`:wq` to save your work.  
`make` to build.  
`cd ../`  
`./core/lib/cli.js execute -l ./language-dhis2.Adaptor -e ./tmp/expression.js -s ./tmp/state.json`  
^^ This assumes your expression calls `post()`

## Modifying or Developing New `language-packages`
*wip*
### Pre-Requisites
1. [Make](http://www.gnu.org/software/make/)
*wip*
