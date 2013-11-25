# TorqueBox BackStage #

BackStage is a Sinatra application that when deployed into a TorqueBox 
server gives you visibility into the apps, queues, topics, message 
processors, jobs, and services, allowing you to browse settings and stats, 
and exposes some actions to allow you to change the operational state of 
the components:

* pause/resume queues and topics
* stop/start message processors, services, and jobs
* execute debug ruby code inside a runtime pool
* view stats on all of the above 

In addition, BackStage allows you to browse messages on a queue, and hides
some of the underlying complexity of how topics are implemented in HornetQ.

It basically acts as an friendly overlay for JMX, so is very easy to 
extend if there is more data you want to see. The data/actions that are
available from BackStage are also available from `/jmx-console` (with
the exception of queue message browsing), but are more accessible in
BackStage.

*Note:* The master branch now only supports TorqueBox 2.x and 3.x. If
you need BackStage for TorqueBox 1.x, install version 0.5.4 of the
gem, or use the tag `v0.5.4` from this repo.

## Installation ##

BackStage can either be installed and deployed as a gem, or deployed from the
application source. 

### As A Gem ###

You can install it via:

    jruby -S gem install torquebox-backstage

By default, the gem command will try to install the latest versions of
the TorqueBox gems that match the pessimistic version requirements of
backstage. If you are installing backstage into a TorqueBox that is
older than the latest release, you'll need to update your gem command
to the latest version and use the `--conservative` flag when
installing (the update is necessary due to a bug in older rubygems
versions that prevents `--conservative` from working properly):

    jruby -S gem update --system
    jruby -S gem install torquebox-backstage --conservative
    
Deploy backstage using the `backstage` command. You can deploy with security
disabled: `jruby -S backstage deploy`
Or enable security by providing a username/password pair: `jruby -S backstage deploy --secure=username:password`

If you are deploying to the torquebox-server gem, you'll need to provide the
`$TORQUEBOX_HOME` environment var. You can obtain that from the `torquebox` 
command and set it like so:

    TORQUEBOX_HOME=`torquebox env torquebox_home` backstage deploy

### From Source ###

*Note:* unless you are doing development on BackStage, the recommended
install method is to build and install the gem (see above).

Clone the [git repo](https://github.com/torquebox/backstage),
then run bundler to install the needed gems (listed in the 
[Gemfile](https://github.com/torquebox/backstage/blob/master/Gemfile)):

    jruby -S gem install bundler # if you haven't done so already
    jruby -S bundle install
    
Once that's done, you can either deploy a deployment descriptor pointing at 
the checked out repo:

    jruby -S rake torquebox:deploy
    
or archive and deploy it as a .knob (zipfile):

    jruby -S rake torquebox:deploy:archive
    
By default, BackStage is deployed to the `/backstage` context (see the `context:` 
setting in `torquebox.yml`).

## API ##

BackStage also provides a RESTful API that allows you to access almost any of the 
data or actions of the web UI (browsing messages via the API is not yet available).
The API provides a top level entry point at `/api` that returns a list of collection 
urls. The data is returned as JSON, and you must either  pass `format=json` as a
query parameter, or set the `Accept:` header to `application/json`. `/api` always
returns JSON, no matter what `Accept:` header or format param you use, and all of 
the urls returned in the JSON include the `format=json` parameter. 

### Example ###

First, we retrieve the API entry point:

    curl http://localhost:8080/backstage/api 

Returns:

    {
      "collections":{
        "apps":"http://localhost:8080/backstage/apps?format=json",
        "queues":"http://localhost:8080/backstage/queues?format=json",
        "topics":"http://localhost:8080/backstage/topics?format=json",
        "message_processors":"http://localhost:8080/backstage/message_processors?format=json",
        "jobs":"http://localhost:8080/backstage/jobs?format=json",
        "services":"http://localhost:8080/backstage/services?format=json",
        "pools":"http://localhost:8080/backstage/pools?format=json",
        "logs":"http://localhost:8080/backstage/logs?format=json"
      }
    }

Then, we'll use the url for services to retrieve the service index:

    curl http://localhost:8080/backstage/services?format=json

Returns:
    
    [
      {
        "resource":"http://localhost:8080/backstage/service/dG9ycXVlYm94LnNlcnZpY2VzOmFwcD1raXRjaGVuLXNpbmsudHJxLG5hbWU9QVNlcnZpY2U=?format=json",
        "name":"AService",
        "app":"http://localhost:8080/backstage/app/dG9ycXVlYm94LmFwcHM6YXBwPWtpdGNoZW4tc2luay50cnE=?format=json",
        "app_name":"kitchen-sink",
        "status":"Started",
        "actions":{
          "stop":"http://localhost:8080/backstage/service/dG9ycXVlYm94LnNlcnZpY2VzOmFwcD1raXRjaGVuLXNpbmsudHJxLG5hbWU9QVNlcnZpY2U=/stop?format=json"
        }
      }
    ]

Each index entry contains the full contents of the entry, along with URL
to access the resource itself. URLs to associated resources are included as
well (the app in this case).

If a resource has actions that can be performed on it, they will appear in
the results under `actions`. Action urls must be called via POST, and 
return the JSON encoded resource:

    curl -X POST http://localhost:8080/backstage/service/dG9ycXVlYm94LnNlcnZpY2VzOmFwcD1raXRjaGVuLXNpbmsudHJxLG5hbWU9QVNlcnZpY2U=/stop?format=json
    
Returns:

    {
      "resource":"http://localhost:8080/backstage/service/dG9ycXVlYm94LnNlcnZpY2VzOmFwcD1raXRjaGVuLXNpbmsudHJxLG5hbWU9QVNlcnZpY2U=?format=json",
      "name":"AService",
      "app":"http://localhost:8080/backstage/app/dG9ycXVlYm94LmFwcHM6YXBwPWtpdGNoZW4tc2luay50cnE=?format=json",
      "app_name":"kitchen-sink",
      "status":"Stopped",
      "actions":{
        "start'":"http://localhost:8080/backstage/service/dG9ycXVlYm94LnNlcnZpY2VzOmFwcD1raXRjaGVuLXNpbmsudHJxLG5hbWU9QVNlcnZpY2U=/start'?format=json"
      }
    }

## Contributing ##

Bug reports, feature requests, and patches are always welcome! See
http://torquebox.org/community/ on how to get in touch with the TorqueBox
crew.

## License ##

Copyright 2011 Red Hat, Inc.

Licensed under the Apache Software License version 2. See 
http://www.apache.org/licenses/LICENSE-2.0 for details.
