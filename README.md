# liferay-cx

This repo contains short Bash script to fetch a Client Extension sample from liferay/liferay-portal into the current directory. It's assumed the samples are located in [https://github.com/liferay/liferay-portal/tree/master/workspaces/liferay-sample-workspace/client-extensions](https://github.com/liferay/liferay-portal/tree/master/workspaces/liferay-sample-workspace/client-extensions).

## Usage

`curl -s https://raw.githubusercontent.com/sustacek/liferay-cx/main/get-cx-sample.sh | bash -s liferay-sample-custom-element-3`

or 

`./get-cx-sample.sh liferay-sample-custom-element-4`

### Without cloning this repo

We'll assume Liferay Workspace is located in the `liferay-workspace` directory:
```
$ cd liferay-workspace/client-extensions

$ curl -s https://raw.githubusercontent.com/sustacek/liferay-cx/main/get-cx-sample.sh | bash -s liferay-sample-custom-element-3
...
CX sample 'liferay-sample-custom-element-3' fetched into directory liferay-sample-custom-element-3@d849cc15/.

$ ls -la liferay-sample-custom-element-3\@d849cc15/
drwxr-xr-x  13 jsustacek  staff     416 Jun 21 14:59 .
drwxr-xr-x@  9 jsustacek  staff     288 Jun 21 14:59 ..
-rw-r--r--   1 jsustacek  staff     274 Jun 21 14:59 .editorconfig
-rw-r--r--   1 jsustacek  staff     548 Jun 21 14:59 .gitignore
-rw-r--r--   1 jsustacek  staff    2306 Jun 21 14:59 angular.json
-rw-r--r--   1 jsustacek  staff      67 Jun 21 14:59 build.gradle
-rw-r--r--   1 jsustacek  staff     492 Jun 21 14:59 client-extension.yaml
-rw-r--r--   1 jsustacek  staff    1037 Jun 21 14:59 package.json
drwxr-xr-x   8 jsustacek  staff     256 Jun 21 14:59 src
-rw-r--r--   1 jsustacek  staff     173 Jun 21 14:59 tsconfig.app.json
-rw-r--r--   1 jsustacek  staff     766 Jun 21 14:59 tsconfig.json
-rw-r--r--   1 jsustacek  staff     177 Jun 21 14:59 tsconfig.spec.json
-rw-r--r--   1 jsustacek  staff  296914 Jun 21 14:59 yarn.lock
```

### With this repo cloned

We'll assume Liferay Workspace is located in the `liferay-workspace` directory:
```
$ alias get-cx-sample='<this_repo_clone_dir>/get-cx-sample.sh'

$ cd liferay-workspace/client-extensions

$ get-cx-sample liferay-sample-custom-element-4
...
CX sample 'liferay-sample-custom-element-4' fetched into directory liferay-sample-custom-element-4@d849cc15/.

$ ls -la liferay-sample-custom-element-4\@d849cc15/
total 24
drwxr-xr-x   6 jsustacek  staff  192 Jun 21 15:06 .
drwxr-xr-x@ 10 jsustacek  staff  320 Jun 21 15:06 ..
drwxr-xr-x   4 jsustacek  staff  128 Jun 21 15:06 assets
-rw-r--r--   1 jsustacek  staff   74 Jun 21 15:06 client-extension.dev.yaml
-rw-r--r--   1 jsustacek  staff  410 Jun 21 15:06 client-extension.yaml
-rw-r--r--   1 jsustacek  staff  168 Jun 21 15:06 package.json
```
