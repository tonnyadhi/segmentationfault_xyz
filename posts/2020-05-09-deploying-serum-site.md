---
title: Deploying Serum Site
date: 2020-05-08
tags: elixir, serum, blog, asdf
---

It's has been a long time since i'm doing a blog, also writing some experiment results or technical tutorial. Now, i'm back. Currently, i'm starting to know more about functional programming and Elixir (because of work). So, i decided to also write this blog using Elixir. More precisely using [Serum](https://github.com/Dalgona/Serum). Serum is a simple static generator written in Elixir. I don't need the functionality of Phoenix for just a simple blog. I'll show you the way on how to deploy Serum

## asdf : the multiple runtime version manager

Do you run multiple runtime system for your work ? You maybe run several version of Ruby, multiple version of Python, and also Rust on your machine. Fear not, there is now a single runtime manager for all those languages. Its written on shell script and can be extended with multiple plugins to support your preferred language and runtime environment. It's called [asdf](https://github.com/asdf-vm/asdf)

So, before i start using Elixir and Serum, i installed this manager on the machine with i'm working with as the server for this blog. Here are the steps you need to deploy asdf into your box.

+ install the dependencies
  - `sudo apt install curl git`
+ clone asdf latest branch
  - `git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.8`
+ add asdf to our shell
  - add the following to your <em>./bashrc</em>
    - `. $HOME/.asdf/asdf.sh`
    - `. $HOME/.asdf/completions/asdf.bash`
+ restart your shell or just sourced your <em>./bashrc</em>
  - `source ~/.bashrc`

## deploying elixir using asdf

elixir and BEAM vm also can be managed using asdf.

+ install asdf erlang/otp plugin and elixir plugin
  - `asdf plugin add erlang`
  - `asdf plugin add elixir`
+ install BEAM vm and erlang/otp runtime using asdf
  - `asdf install erlang 22.3.3
+ install elixir using asdf
  - `asdf install elixir 1.10.3-otp-22

## creating your serum site

serum is really easy to install, because its already wrapped into [Hex package](https://hex.pm/packages/serum)

+ install serum as mix archive
  - `mix archive.install hex serum_new`
+ initiate your site
  - `mix serum.new $HOME/segmentationfault_xyz`
+ fetch the dependencies
  - `cd $HOME/segmentationfault_xyz`
  - `mix deps.get && mix compile`
+ start to write content
  - post in form of pages are located under <em>/pages</em> directory
  - blog posts are located under <em>/posts</em> directory. write a post in a form of [markdown document formatted](https://markdown-guide.readthedocs.io) add a theme into your site
+ add a theme as dependency on your <em>mix.exs</em> file
        defp deps do
        [
            {:serum, "~> 1.4"},
            {:serum_theme_essence, "~> 1.0"}
        ]
        end
+ in order to check your post, you can run a serum server on your box
  - `$ mix serum.server --port 8080`
+ build your site
  - `MIX_ENV=prod mix serum.build`
+ all site structure and assets will be put under <em>/site</em> directory. you can serve this directory using web server such as nginx
+ done. enjoy!


Note : this site structure is put under this [github repository](https://github.com/tonnyadhi/segmentationfault_xyz).

