# Greenpeace Planet4 docker development environment

![Planet4](https://cdn-images-1.medium.com/letterbox/300/36/50/50/1*XcutrEHk0HYv-spjnOej2w.png?source=logoAvatar-ec5f4e3b2e43---fded7925f62)

## What is Planet4?

Planet4 is the NEW Greenpeace web platform

## What is this repository?

This repository contains needed files to set up a docker development environment that consists on:

 * Planet4 php-fpm container serving [planet4-base](https://github.com/greenpeace/planet4-base)
 * MySQL container as a database engines
 * Phpmyadmin container as a database administration application
 * nginx container to proxy requests to php-fpm
 * redis container for object caching
 * redis-commander container as a redis administration application

## How to set up the docker environment

### WARNING WINDOWS USERS

Note this repository has not yet been tested on windows platforms yet, any feedback will be welcome!

### Requirements

First things first, requirements for running this development environment:

  * [install docker](https://docs.docker.com/engine/installation/)

For MacOS and Windows users docker installation already includes docker-compose
GNU/Linux users have to install docker-compose separately:

  * [install docker compose](https://docs.docker.com/compose/install/)

### Running planet4 development environment

Recommended setup is to clone [planet4-base](https://github.com/greenpeace/planet4-base) and link it to the planet4 container.

1. Install docker
1. (Optional) Install portainer (you will need to create a directory, eg. "/Users/user/dev/docker"
    ```bash
     $ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v /Users/user/dev/docker:/data portainer/portainer
    ```
1. (Optional) In your browser go to : http://localhost:9000 (portainer's main page)
1. (Optional) Create username/password
1. (Optional) Select "Manage the Docker instance where Portainer is running" and press "connect"
1. Pull the planet4-base repository to a directory, eg. /Users/user/Documents/projects/planet4/planet4-base 
    ```bash
     $ git clone https://github.com/greenpeace/planet4-base
    ```
1. And then switch to the develop branch
    ```bash
     $ git checkout develop
    ```      
1. In your computer, create the following directory somewhere /somewhere/mysql (your database will be stored here, so that it does not get deleted everytime the container gets rebuilt)
    ```bash
     $ mkdir /Users/user/Documents/projects/planet4/mysql
    ```
1. Copy the file docker-compose.override.yml.example into docker-compose.override.yml 
1. Edit the file docker-compose.override.yml and put the relevant paths from steps 1 and 2 in the parts before the :
    ```yaml
      planet4:
          volumes:
            - **/Users/user/Documents/projects/planet4/planet4-base**:/var/www/html:rw
      nginx:
          volumes:
            - **/Users/user/Documents/projects/planet4/planet4-base**:/var/www/html:rw
      mysql:
          volumes:
            - **/Users/user/Documents/projects/planet4**/mysql:/var/lib/mysql:rw

    ```
1. Copy the file variables.env.example to variables.env
1. Launch docker-compose
    ```bash
      $ cd planet4-docker-compose
      $ docker-compose up
    ```
1. Edit hosts file (/etc/hosts linux, mac ) to point 172.20.0.4 to test.planet4.dev.
    ```bash
        172.20.0.4      test.planet4.dev       
    ```
You should be able to see all your docker containers at http://localhost:9000.

Your p4 website at: http://test.planet4.dev.

Phpmyadmin at: http://127.0.0.1:8083.

Redis-commander at: http://127.0.0.1:8084.

## Composer

You can run composer inside planet4 container.

```bash
  $ composer install
  $ composer update
```

## Wp cli

You can run wp cli inside planet4 container using wp.

```bash
  $ wp user list
  $ wp user delete dev
```

## Mounted directories

Insert the repos (separated by | ) that you want to be cloned in the plugins directory by altering PLUGINS_REPOS variable in variables.env
PLUGINS_REPOS='https://github.com/greenpeace/planet4-plugin-action-content-type|https://github.com/greenpeace/planet4-plugin-engagingnetworks'

Also you need to map host os user to user nginx in the container so you can edit files in your os and nginx be able to read the mounted directories.
Edit USERID variable in variables.env to your user id (needed for linux distributions).
USERID=1000


## Environment variables

This docker environment relies on the mysql official image. variables.env.example contains all the needed variables.
Normally it is not essential to change of override any variable, so a simple copy of the variables.env.example to variables.env would do the job.

MySQL container variables:

  * MYSQL_ROOT_PASSWORD=test
  * MYSQL_DATABASE=planet4
  * MYSQL_USER=develop
  * MYSQL_PASSWORD=test_develop

Planet4 container variables:

  * DBUSER=develop
  * DBPASS=test_develop
  * DBNAME=planet4
  * DBHOST=db

## Notes
TODO
File watchers for scss/js compiling
Change test domain
Preserve uploads/images