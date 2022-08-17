FROM gitlab/gitlab-ce:13.2.4-ce.0

#copy ldap.rb
COPY ./ldap.rb   /opt/gitlab/embedded/lib/ruby/gems/2.6.0/gems/net-ldap-0.16.2/lib/net/