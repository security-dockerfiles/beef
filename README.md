Docker for BeEF
---------------

## Usage

### Build

```sh
docker build -t beef https://github.com/security-dockerfiles/beef.git
```

You can try to build beef from the latest commit:
```sh
docker build -t beef --build-args COMMIT=master https://github.com/security-dockerfiles/beef.git
```

### Run

Run pre-built image from the docker hub:
```sh
docker run -itd \
           --name=beef \
           -p 3000:3000 \
           -p 6789:6789 \
           -p 61985:61985 \
           -p 61986:61986 \
           ilyaglow/beef
```

BeEF will be available at `http://localhost:3000/ui/panel`. By default the user
is `beef` and the password is randomly generated. You can see the actual
credentials when container starts and with `docker logs beef`.

The beef user and password pair could be easily overridden by using the
following environment variables:
* `BEEF_USER`
* `BEEF_PASSWORD`

Start container with customized credentials:

```sh
docker run -itd \
           --name=beef \
           -p 3000:3000 \
           -p 6789:6789 \
           -p 61985:61985 \
           -p 61986:61986 \
           -e BEEF_USER=customuser \
           -e BEEF_PASSWORD=custompassphrase \
           ilyaglow/beef
```

### Why another docker

I couldn't find any suitable Dockerfile out there for the recent version of
[BeEF](https://github.com/beefproject/beef) that is actually working.

Moreover I have a personal priority to run app in the container without root 
privileges. Most developers seem to ignore this somehow.

### Why not based on Alpine

BeEF's Gemfile has gem `therubyracer` which depends on `libv8` gem precompiled
for `glibc` (Alpine uses `muslc`). One option is to build `libv8` from sources
and another is to wait for a solution. I stick with the latter for now.
