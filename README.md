# gitlab-docker


# upgrade
https://docs.gitlab.com/ee/update/#upgrade-paths

8.11.Z -> 8.12.0 -> 8.17.7 -> 9.5.10 -> 10.8.7 -> 11.11.8 -> 12.0.12 -> 12.1.17 -> 12.10.14 -> 13.0.14 -> 13.1.11 -> 13.8.8 -> 13.12.15 -> 14.0.12 -> 14.3.6 -> 14.9.5 -> 14.10.Z -> 15.0.Z -> latest 15.Y.Z



# 13.2.4 -> 13.8.8
letsencrypt會一直報錯 需設定
```
      GITLAB_OMNIBUS_CONFIG: |
        letsencrypt['enable'] = false
```