# gitlab-docker


# upgrade
https://docs.gitlab.com/ee/update/#upgrade-paths

8.11.Z -> 8.12.0 -> 8.17.7 -> 9.5.10 -> 10.8.7 -> 11.11.8 -> 12.0.12 -> 12.1.17 -> 12.10.14 -> 13.0.14 -> 13.1.11 -> 13.8.8 -> 13.12.15 -> 14.0.12 -> 14.3.6 -> 14.9.5 -> 14.10.Z -> 15.0.Z -> 15.4.0 -> latest 15.Y.Z





# ldap.rb
唯一有改的值 DefaultForceNoPage = false改成true
```
DefaultForceNoPage = true
```

13.2.4
```
/opt/gitlab/embedded/lib/ruby/gems/2.6.0/gems/net-ldap-0.16.2/lib/net/ldap.rb
```

13.8.8
```
/opt/gitlab/embedded/lib/ruby/gems/2.7.0/gems/net-ldap-0.16.3/lib/net/ldap.rb
```

13.2.4 -> 13.8.8 ```ldap.rb``` 內容有變動



# 13.2.4 -> 13.8.8
letsencrypt會一直報錯 需設定
```
      GITLAB_OMNIBUS_CONFIG: |
        letsencrypt['enable'] = false
```




# 14.0.12 -> 14.3.6
https://docs.gitlab.com/ee/user/admin_area/monitoring/background_migrations.html#database-migrations-failing-because-of-batched-background-migration-not-finished

migrations過程中 check state一直失敗

```Expected process to exit with [0], but received '1'```


```
gitlab    |     ================================================================================

gitlab    |     Error executing action `run` on resource 'rails_migration[gitlab-rails]'

gitlab    |     ================================================================================

gitlab    |    

gitlab    |     Mixlib::ShellOut::ShellCommandFailed

gitlab    |     ------------------------------------

gitlab    |     bash[migrate gitlab-rails database] (/opt/gitlab/embedded/cookbooks/cache/cookbooks/gitlab/resources/rails_migration.rb line 16) had an error: Mixlib::ShellOut::ShellCommandFailed: Expected process to exit with [0], but received '1'

gitlab    |     ---- Begin output of "bash"  "/tmp/chef-script20220908-28-dj60o9" ----

gitlab    |     STDOUT: rake aborted!

gitlab    |     StandardError: An error has occurred, all later migrations canceled:

gitlab    |    

gitlab    |     Expected batched background migration for the given configuration to be marked as 'finished', but it is 'active':  {:job_class_name=>"CopyColumnUsingBackgroundMigrationJob", :table_name=>"events", :column_name=>"id", :job_arguments=>[["id"], ["id_convert_to_bigint"]]}

gitlab    |    

gitlab    |     Finalize it manualy by running

gitlab    |    

gitlab    |             sudo gitlab-rake gitlab:background_migrations:finalize[CopyColumnUsingBackgroundMigrationJob,events,id,'[["id"]\, ["id_convert_to_bigint"]]']

gitlab    |    

gitlab    |     For more information, check the documentation

gitlab    |    

gitlab    |             https://docs.gitlab.com/ee/user/admin_area/monitoring/background_migrations.html#database-migrations-failing-because-of-batched-background-migration-not-finished

gitlab    |     /opt/gitlab/embedded/service/gitlab-rails/lib/gitlab/database/migration_helpers.rb:1109:in `ensure_batched_background_migration_is_finished'

gitlab    |     /opt/gitlab/embedded/service/gitlab-rails/db/post_migrate/20210622045705_finalize_events_bigint_conversion.rb:11:in `up'

gitlab    |     /opt/gitlab/embedded/service/gitlab-rails/lib/gitlab/database/migrations/lock_retry_mixin.rb:31:in `ddl_transaction'

gitlab    |     /opt/gitlab/embedded/service/gitlab-rails/lib/tasks/gitlab/db.rake:61:in `block (3 levels) in <top (required)>'

gitlab    |     /opt/gitlab/embedded/bin/bundle:23:in `load'

gitlab    |     /opt/gitlab/embedded/bin/bundle:23:in `<main>'
```


## solution
要在```docker-compose up -d```啟動後 馬上連進去container下指令

```
docker exec -it GitlabID bash
```
```
sudo gitlab-rake gitlab:background_migrations:finalize[<job_class_name>,<table_name>,<column_name>,'<job_arguments>']

sudo gitlab-rake gitlab:background_migrations:finalize[CopyColumnUsingBackgroundMigrationJob,events,id,'[["id"]\, ["id_convert_to_bigint"]]']
```



# 12.10.14 -> 13.0.14
```
================================================================================
Recipe Compile Error in /opt/gitlab/embedded/cookbooks/cache/cookbooks/gitlab/recipes/default.rb
================================================================================

RuntimeError
------------
Only one web server (Puma or Unicorn) can be enabled at the same time!
```

https://forum.gitlab.com/t/unable-to-upgrade-past-13-0-14/45586/4

## solution
edit ```/etc/gitlab/gitlab.rb```
```
unicorn['enable'] = false
puma['enable'] = true
```
