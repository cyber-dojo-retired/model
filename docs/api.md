# API
- - - -
## POST group_create(manifests:,options:)
Creates a new group exercise from `manifests[0]`, and returns its id.
- parameters [(JSON-in)](#json-in)
  * **manifests:[Hash,...]**.
  At present only `manifests[0]` is used.
  The array is for a planned feature.
  For example, a [custom-start-points](https://github.com/cyber-dojo/custom-start-points) manifest.  
  * **options:Hash[**.
  Currently unused (and defaulted). For a planned feature.
- returns [(JSON-out)](#json-out)
  * the `id` of the created group.

- - - -
## GET group_exists?(id:)
Determines if a group exercise with the given `id` exists.
- parameters [(JSON-in)](#json-in)
  * **id:String**.
- returns [(JSON-out)](#json-out)
  * `true` if a group with the given `id` exists, otherwise `false`.
- example
  ```bash
  $ curl \
    --data '{"id:"dFg8Us"}' \
    --header 'Content-type: application/json' \
    --silent \
    --request GET \
      http://${IP_ADDRESS}:${PORT}/group_exists?

  {"group_exists?":false}
  ```

- - - -
## GET group_manifest(id:)
Gets the manifest used to create the group exercise with the given `id`.
- parameters [(JSON-in)](#json-in)
  * **id:String**.
- returns [(JSON-out)](#json-out)
  * the manifest of the group with the given `id`.
- example
  ```bash
  $ curl \
    --data '{"id:"dFg8Us"}' \
    --header 'Content-type: application/json' \
    --silent \
    --request GET \
      http://${IP_ADDRESS}:${PORT}/group_manifest

  {"group_manifest":...}
  ```

- - - -
## POST group_join(id:,indexes:)
Creates a new kata in the group with the given `id` and returns the kata's id.
- parameters [(JSON-in)](#json-in)
  * **id:String**.
  * **indexes:Array[int]**
  Currently unused (and defaulted). For a planned feature.  
- returns [(JSON-out)](#json-out)
  * the `id` of the created kata, or `nil` if the group is already full.
- example
```bash
$ curl \
  --data '{"id:"dFg8Us"}' \
  --header 'Content-type: application/json' \
  --silent \
  --request GET \
    http://${IP_ADDRESS}:${PORT}/group_join

{"group_join":"a8gVRN"}
```

- - - -
## GET group_avatars(id:)
Returns an array of avatar indexes and kata-ids of the katas that have joined the
group with the given `id`.
- parameters [(JSON-in)](#json-in)
  * **id:String**.
- returns [(JSON-out)](#json-out)
  * an array of `[index,id]` elements.
- example
```bash
$ curl \
  --data '{"id:"dFg8Us"}' \
  --header 'Content-type: application/json' \
  --silent \
  --request GET \
    http://${IP_ADDRESS}:${PORT}/group_avatars

{"group_avatars":[[7,"a8gVRN"],[29,"gUNjUV"]]}
```

- - - -
## POST kata_create(manifest:,options:)
Creates a new kata exercise from `manifest`, and returns its id.
- parameters [(JSON-in)](#json-in)
  * **manifest:Hash**.
  For example, a [custom-start-points](https://github.com/cyber-dojo/custom-start-points) manifest.  
  * **options:Hash**.
  Currently unused (and defaulted). For a planned feature.
- returns [(JSON-out)](#json-out)
  * the `id` of the created kata.

- - - -
## GET kata_exists?(id:)
Determines if a kata exercise with the given `id` exists.
- parameters [(JSON-in)](#json-in)
  * **id:String**.
- returns [(JSON-out)](#json-out)
  * `true` if a kata with the given `id` exists, otherwise `false`.
- example
  ```bash
  $ curl \
    --data '{"id:"4ScKVJ"}' \
    --header 'Content-type: application/json' \
    --silent \
    --request GET \
      http://${IP_ADDRESS}:${PORT}/kata_exists?

  {"kata_exists?":false}
  ```

- - - -
## GET kata_manifest(id:)
Gets the manifest used to create the kata exercise with the given `id`.
- parameters [(JSON-in)](#json-in)
  * **id:String**.
- returns [(JSON-out)](#json-out)
  * the manifest of the kata with the given `id`.
- example
  ```bash
  $ curl \
    --data '{"id:"4ScKVJ"}' \
    --header 'Content-type: application/json' \
    --silent \
    --request GET \
      http://${IP_ADDRESS}:${PORT}/kata_manifest

  {"kata_manifest":...}
  ```

- - - -
## GET sha
The git commit sha used to create the Docker image.
- parameters
  * none
- returns [(JSON-out)](#json-out)
  * the 40 character commit sha string.
- example
  ```bash     
  $ curl --silent --request GET http://${IP_ADDRESS}:${PORT}/sha

  {"sha":"41d7e6068ab75716e4c7b9262a3a44323b4d1448"}
  ```

- - - -
## GET alive?
Tests if the service is alive.
Used as a [Kubernetes](https://kubernetes.io/) liveness probe.  
- parameters
  * none
- returns [(JSON-out)](#json-out)
  * **true**
- example
  ```bash     
  $ curl --silent --request GET http://${IP_ADDRESS}:${PORT}/alive?

  {"alive?":true}
  ```

- - - -
## GET healthy?
Tests if the service is ready to handle requests.
Used as a Docker HEALTHCHECK probe.
- parameters
  * none
- returns [(JSON-out)](#json-out)
  * **true** if the service is healthy
  * **false** if the service is not healthy
- example
  ```bash     
  $ curl --silent --request GET http://${IP_ADDRESS}:${PORT}/healthy?

  {"healthy?":false}
  ```

- - - -
## GET ready?
Tests if the service is ready to handle requests.
Used as a [Kubernetes](https://kubernetes.io/) readiness probe.
- parameters
  * none
- returns [(JSON-out)](#json-out)
  * **true** if the service is ready
  * **false** if the service is not ready
- example
  ```bash     
  $ curl --silent --request GET http://${IP_ADDRESS}:${PORT}/ready?

  {"ready?":false}
  ```

- - - -
## JSON in
- All methods pass any arguments as a json hash in the http request body.
  * If there are no arguments you can use `''` (which is the default
    for `curl --data`) instead of `'{}'`.

- - - -
## JSON out      
- All methods return a json hash in the http response body.
  * If the method completes, a string key equals the method's name. eg
    ```bash
    $ curl --silent --request GET http://${IP_ADDRESS}:${PORT}/ready?

    {"ready?":true}
    ```
  * If the method raises an exception, a string key equals `"exception"`, with
    a json-hash as its value. eg
    ```bash
    $ curl --silent --request POST http://${IP_ADDRESS}:${PORT}/group_create | jq      

    {
      "exception": {
        "path": "/group_create",
        "body": "",
        "message": "...",
        "backtrace": [
          ...
          "/usr/bin/rackup:23:in `<main>'"
        ]
      }
    }
    ```
