* 0.5.4 - 2011-09-27
  * Don't ship the Gemfile.lock.

* 0.5.3 - 2011-09-13
  * Use the correct message count for paging messages.
  * A fix for the typo that broke display of services (from wollsau).

* 0.5.2 - 2011-08-10
  * Updated to use TorqueBox 1.1.1 gems
  * Added caches and groups to API

* 0.5.1 - 2011-07-29
  * Resolved error with cache name not being defined.
  
* 0.5 - 2011-07-28
  * Added Cluster Properties to dashboard (from Penumbra)
  * Added Infinispan cache links to dashboard  (from Penumbra)
  * Added Caches tab view (from Penumbra)

* 0.4.3 - 2011-07-14
  * Updated to use TorqueBox 1.1 gems

* 0.4.2 - 2011-06-20
  * Locked gemspec gem versions to match Gemfile.lock versions (issue #5)
  * Restored Rakefile to repo
  
* 0.4.1 - 2011-06-06
  * Cleaned up gem dependencies.
  
* 0.4.0 - 2011-05-27
  * Updated to use the TorqueBox 1.0.1 gems
  * Serve jquery.min.js from BackStage instead of pulling from google.
  * Fix for jobs dashboard (name vs. display_name from @davidglassborow)
  * Queue browsing is now paginated
  * Queues/Topics can now be cleared
  * Sinatra dependency upgraded to 1.2.6
  
* 0.3.2 - 2011-05-03
  * Fixed typo in dashboard Message Processor index link
  
* 0.3.1 - 2011-04-29
  * public/ now included in the gem
  
* 0.3.0 - 2011-04-29
  * you can now tail application and jboss logs
  * added a dashboard
  * updated to use the TorqueBox 1.0.0.Final gems
  
* 0.2.1 - 2011-04-27
  * The deployment descriptor name was changed from backstage-knob.yml to torquebox-backstage-knob.yml
  
* 0.2.0 - 2011-04-26
  * if the queue isn't available via jndi, just log an error instead of raising
  * updated to use the TorqueBox 1.0.0.CR2 gems
  
* 0.1.2 and earlier
  * stuff happened
