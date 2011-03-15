= TorqueBox BackStage =

BackStage is an app that when deployed into a TorqueBox server gives you
visibility into the apps, queues, topics, message processors, jobs, and
services, giving you stats about each.

You also have some control over these components:

* pause/unpause queues and topics
* browse messages on a queue 
* stop/start message processors, services, and jobs
* view stats on all of the above 

It basically just acts as an friendly overlay for JMX, so is very easy to 
extend if there is more data you want to see.

== Authentication ==

By default, access to BackStage is wide open. You can secure it by setting 
`USERNAME` and `PASSWORD` environment variables in `torquebox.yml`:

    environment:
      USERNAME: backstage
      PASSWORD: pass

This will enable basic HTTP authentication.

== Deployment ==

To deploy BackStage, clone the [git repo](https://github.com/torquebox/backstage),
then (install and) run bundler:

    jruby -S gem install bundler # if you haven't done so already
    jruby -S bundle install
    
Once that's done, you can either deploy a deployment descriptor pointing at 
the checked out repo:

    jruby -S rake torquebox:deploy
    
or archive and deploy it as a .knob (zipfile):

    jruby -S rake torquebox:deploy:archive
    
By default, BackStage is deployed to the /backstage context (see the `context:` 
setting in `torquebox.yml`).

== API ==

BackStage also provides a RESTful API that allows you to access almost any of the 
data or actions of the web UI (browsing messages via the API is not yet available).
The API provides a top level entry point at `/api` that returns a list of collection 
urls. The data is returned as JSON, and you must either  pass `format=json` as a
query parameter, or set the `Accept:` header to `application/json`. `/api` always
returns JSON, no matter what `Accept:` header or format param you use, and all of 
the urls returned in the JSON include the `format=json` parameter. 

=== Example ===

This example uses curl. First, we retrieve the API entry point:

    curl http://localhost:8080/backstage/api 

Returns:

    {
      "collections":{
        "apps":"http://localhost:8080/backstage/apps?format=json",
        "queues":"http://localhost:8080/backstage/queues?format=json",
        "topics":"http://localhost:8080/backstage/topics?format=json",
        "message_processors":"http://localhost:8080/backstage/message_processors?format=json",
        "jobs":"http://localhost:8080/backstage/jobs?format=json",
        "services":"http://localhost:8080/backstage/services?format=json"
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

== LICENSE ==

Copyright 2011 Red Hat, Inc.

Licensed under the Apache Software License version 2. See 
http://www.apache.org/licenses/LICENSE-2.0 for details.
