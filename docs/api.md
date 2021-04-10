# API
- - - -
## POST group_create(manifests:,options:)
Creates a new group exercise from `manifests[0]`, and returns its id.
- parameters [(JSON-in)](#json-in)
  * **manifests:[Hash,...]**.
  At present only `manifests[0]` is used.
  The array is for a planned feature.
  For example, a [custom-start-points](https://github.com/cyber-dojo/custom-start-points) manifest.  
  * **options:Hash**.
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

  {"group_exists?":true}
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
      http://${IP_ADDRESS}:${PORT}/group_manifest | jq

  {
    "group_manifest": {
      "display_name": "Bash, bats",
      "image_name": "cyberdojofoundation/bash_bats:53d0c9c",
      "filename_extension": [
        ".sh"
      ],
      "tab_size": 4,
      "visible_files": {
        "test_hiker.sh": { "content": "..." },
        "bats_help.txt": { "content": "..." },
        "hiker.sh": { "content": "..." },
        "cyber-dojo.sh": { "content": "..." },
        "readme.txt": { "content": "..." }
      },
      "exercise": "LCD Digits",
      "version": 1,
      "created": [2020,10,19,12,51,32,991192],
      "id": "REf1t8",
      "highlight_filenames": [],
      "max_seconds": 10,
      "progress_regexs": []
    }
  }  
  ```

- - - -
## POST group_join(id:,indexes:)
Creates a new kata in the group with the given `id` and returns the kata's id.
- parameters [(JSON-in)](#json-in)
  * **id:String**.
  * **indexes:Array[int]**
  Currently unused (and defaulted). For a planned feature.  
- returns [(JSON-out)](#json-out)
  * the `id` of the created kata, or `null` if the group is already full.
- example
  ```bash
  $ curl \
    --data '{"id:"dFg8Us"}' \
    --header 'Content-type: application/json' \
    --silent \
    --request POST \
      http://${IP_ADDRESS}:${PORT}/group_join

  {"group_join":"a8gVRN"}
  ```

- - - -
## GET group_joined(id:)
Returns the kata-id and kata-events keyed against the kata's avatar-index
for the katas that have joined a group. The group can be specified with the group's `id`
**or** with the `id` of any kata in the group.
- parameters [(JSON-in)](#json-in)
  * **id:String**.
- returns [(JSON-out)](#json-out)
  * a **Hash**.
- example
  ```bash
  $ curl \
    --data '{"id:"dFg8Us"}' \
    --header 'Content-type: application/json' \
    --silent \
    --request GET \
      http://${IP_ADDRESS}:${PORT}/group_joined | jq

  {
    "group_joined": {
      "7": {
        "id": "a8gVRN",
        "events": [...]
      },
      "29": {
        "id": "gUNjUV",
        "events": [...]
      },
      ...
     }
  }
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
      http://${IP_ADDRESS}:${PORT}/kata_manifest | jq

  {
    "kata_manifest": {
      "display_name": "Bash, bats",
      "image_name": "cyberdojofoundation/bash_bats:53d0c9c",
      "filename_extension": [ ".sh" ],
      "tab_size": 4,
      "visible_files": {
        "test_hiker.sh": { "content": "..." },
        "bats_help.txt": { "content": "..." },
        "hiker.sh": { "content": "..." },
        "cyber-dojo.sh": { "content": "..." },
        "readme.txt": { "content": "..." }
      },
      "exercise": "LCD Digits",
      "version": 1,
      "created": [2020,10,19,12,52,46,396907],
      "group_id": "REf1t8",
      "group_index": 44,
      "id": "4ScKVJ",
      "highlight_filenames": [],
      "max_seconds": 10,
      "progress_regexs": []
    }
  }  
  ```


- - - -
## GET kata_events(id:)
Gets the events summary for the kata exercise with the given `id`.
- parameters [(JSON-in)](#json-in)
  * **id:String**.
- returns [(JSON-out)](#json-out)
  * the events summary of the kata with the given `id`.
- example
  ```bash
  $ curl \
    --data '{"id:"4ScKVJ"}' \
    --header 'Content-type: application/json' \
    --silent \
    --request GET \
      http://${IP_ADDRESS}:${PORT}/kata_events | jq

  {
    "kata_events": [
      { "index": 0,
         "time": [2020,10,19,12,52,46,396907],
         "event": "created"
      },
      { "time": [2020,10,19,12,52,54,772809],
        "duration": 0.491393,
        "colour": "red",
        "predicted": "none",
        "index": 1
      },
      { "time": [2020,10,19,12,52,58,547002],
        "duration": 0.426736,
        "colour": "amber",
        "predicted": "none",
        "index": 2
      },
      { "time": [2020,10,19,12,53,3,256202],
        "duration": 0.438522,
        "colour": "green",
        "predicted": "none",
        "index": 3
      }
    ]
  }
  ```


- - - -
## GET kata_event(id:,index:)
Gets the details for the kata exercise event with the given `id` and `index`
- parameters [(JSON-in)](#json-in)
  * **id:String**.
  * **index:int**.
- returns [(JSON-out)](#json-out)
  * the event with the given `id` and `index`.
- example
  ```bash
  $ curl \
    --data '{"id:"4ScKVJ","index":2}' \
    --header 'Content-type: application/json' \
    --silent \
    --request GET \
      http://${IP_ADDRESS}:${PORT}/kata_event | jq

  {
     "kata_event":{
     "files": {
       "test_hiker.sh": { "content": "..." },
       "bats_help.txt": { "content": "..." },
       "hiker.sh": { "content": "..." },
       "cyber-dojo.sh": { "content": "..." },
       "readme.txt": { "content": "..." }
     },
     "stdout": {
       "content": "...",
       "truncated": false
     },
     "stderr": {
       "content": "...",
       "truncated": false
     },
     "status": "1",
     "time": [2020,10,19,12,52,58,547002],
     "duration": 0.426736,
     "colour": "amber",
     "predicted": "none",
     "index": 2
   }
   ```

- - - -
## GET katas_events(ids:,indexes:)
Gets the details for the kata exercise events with the given `ids` and `indexes`.
A Batch-Method for kata_event(id,index).
- parameters [(JSON-in)](#json-in)
  * **ids:Array[String]**.
  * **index:Array[int]**.
- returns [(JSON-out)](#json-out)
  * the events with the given `ids` and `indexes`.
- example
  ```bash
  $ curl \
    --data '{"ids:["4ScKVJ","De87Aa"],"indexes":[23,45]}' \
    --header 'Content-type: application/json' \
    --silent \
    --request GET \
      http://${IP_ADDRESS}:${PORT}/katas_events | jq

  {
     "katas_events": {
       "4ScKVJ": {
         "23": {
           ...
         }
       },
       "De87Aa": {
         "45": {
           ...
         }
       }
     }
   }
   ```


- - - -
## POST kata_ran_tests(id:,index:,files:,stdout:,stderr:,status:,summary:)

- - - -
## POST kata_predicted_right(id:,index:,files:,stdout:,stderr:,status:,summary:)

- - - -
## POST kata_predicted_wrong(id:,index:,files:,stdout:,stderr:,status:,summary:)

- - - -
## POST kata_reverted(id:,index:,files:,stdout:,stderr:,status:,summary:)

- - - -
## POST kata_checked_out(id:,index:,files:,stdout:,stderr:,status:,summary:)

- - - -
## GET kata_option_get(id:,name:)

- - - -
## POST kata_option_set(id:,name:,value:)


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
## GET ready?
Tests if the service is ready to handle requests.
Used as a Docker HEALTHCHECK probe, and a [Kubernetes](https://kubernetes.io/) readyness probe.
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
