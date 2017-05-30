Docker for BeEF
---------------

### Why another docker

I couldn't find any suitable Dockerfile out there for the recent version of [BeEF](https://github.com/beefproject/beef) that is actually working.

Moreover I have a personal priority to run app in the container without root privileges. Most developers seem to ignore this somehow.

### Why not based on Alpine

BeEF's Gemfile has gem `therubyracer` which depends on `libv8` gem precompiled for `glibc` (Alpine uses `muslc`). One option is to build `libv8` from sources and another is to wait for a solution. I stick with the latter for now.

## Usage

```
docker run -it -p 3000:3000 -p 6789:6789 -p 61985:61985 -p 61986:61986 ilyaglow/beef
```

BeEF will be available at `http://localhost:3000/ui/panel`
