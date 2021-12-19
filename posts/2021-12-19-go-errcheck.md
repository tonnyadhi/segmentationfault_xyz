---
title: Go Errcheck
date: 2021-12-19
tags: golang, error check,  error handling
---

Today i learned on [go-errcheck](https://github.com/kisielk/errcheck). This small utility is quite handy to check unchecked error handling in our code.
I found out this tool when refreshing my Go lesson on [Learning Go With Tests](https://quii.gitbook.io/learn-go-with-tests/go-fundamentals/pointers-and-errors) during error handling chapter.

## Installation
go-errcheck need go 1.12 or newer.

Installation on go <= 1.17
`go get -u github.com/kisielk/errcheck`

Installation on  go >= 1.17
`go install github.com/kisielk/errcheck@lates`

If you are using asdf as package manager like me, don't forget to add your $GOROOT/bin into the path
`export PATH=$PATH:$HOME/.asdf/installs/golang/1.17.2/packages/bin`     

## Usage
Check current directory
`errcheck .`

Check all packages  beneath  current  directory
`errcheck  all`

Check package of interest
`errcheck github.com/kisielk/errcheck/testdata`

If there is unhandled error, it  will reporting back to you
`wallet_test.go:17:18: wallet.Withdraw(Bitcoin(10))`
