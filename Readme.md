# Claude Coding Sandbox 

For PHP, Node, Python

## Purpose of this Repository

I was using Claude Code on my bare metal, and noticed that even if I instructed  it in the global Claude.md  not to stray outside the project directory, it would happily ignore my instructions and run `cat`  on any damned file it felt it needed. It also occasionally ignores directives in the settings.json. So I decided that for most of my work, I wanted a sandbox for doing my Claude coding. 

However, on occasion, I do want to run it on bare metal, e.g. if it needs a resource not installed in the sandbox. This makes it important to construct the sandbox container in such a way, that I mount my configuration paths into the container. These must be identical in sandbox and host environment for Claude Code to correctly save memory and configurations. In my case, that is:

```bash
~/.claude
~/.config/claude
~/.mempalace
~/.memsearch
~/myCodingProjectsDir
```

Since Claude Code stores paths in its configuration files, *the container must have identical paths*, otherwise using Claude Code inside the sandbox creates different entries in configs and memory as  outside the sandbox. 
## Bug Reports, Branches
Bug reports, suggestions, and branches for other dev environments are explicitly welcome. 
Use [Issues](https://github.com/jmuxfeldt/claude-coding-sandbox/issues) and [Discussions](https://github.com/jmuxfeldt/claude-coding-sandbox/discussions) repectively.
## Example Only

This is only an example, which you can adjust to your own needs. There are certain central concepts governing the configuration:

1. An .env file containing a HOME_DIR and a WORKING_DIR variable. These will be  mirrored inside the container according to the docker-compose.yaml and the Docker file. ***The $HOME directory in the docker container is set to HOME_DIR  automatically on build. If you change these, you must rebuild the container.   This part is crucial for Claude Code.***
2. You can change everything else, in particular which projects you want to mount. Maybe you need to mount several project directories. ***Claude doesn't care, so long as they have the same paths inside the container as outside the container***.

## Installation

1. Clone the master branch. 

2. Copy .env.example to .env and edit .env. In my case,  
   HOME_DIR  is exactly like on macOS: /Users/myUserName , and the WORKING_DIR  is /Users/myUserName/myCodingDir.
   On Windows or on Linux this will be different. 

3. (optional) Edit .bashrc to your own preferences.  Also, change php.ini, if you think it is needed. 

4. (optional)  Add any special mounts to the docker-compose file. If they mount into new directories, you must create these directories in the Dockerfile. 

5. Add the following function to your ~/.profile or ~/.bashrc file: edit CHANGE_ME!!

   ```bash
   claude-dev() {
     DIR=$(pwd)
     COMPOSE_DIR=CHANGE_ME ##CHANGE!!!
     local BUILD_FLAG=""
     if [[ "$1" == "--build" ]]; then
       BUILD_FLAG="--build"
     fi
     docker compose --env-file ${COMPOSE_DIR}/.env -f ${COMPOSE_DIR}/docker-compose.yml up -d $BUILD_FLAG && \
     docker exec -it claude-dev bash -c "cd '$DIR'; exec bash"
   }
   ```

   **Change COMPOSE_DIR to the path of where you checked out this repository.**

7. run `source ~/.profile` or `source ~/.bashrc`.   after that, you can cd to one of your projects on the host machine, and simply run ``claude-dev`` . It will start (and if necessary build) the container, and inside the container, you will already be in your project directory.  

8. Now, inside the container, run ``claude`` .  The first time and after a rebuild, you will be asked to authenticate. 

9. Your Claude memory and other settings are now shared correctly between the host and sandbox, *so long as you have mirrored all relevant directories with identical paths*.  Your Claude Code now only has access to what you have mounted in the container. 
