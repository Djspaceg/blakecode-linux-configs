# Amazon Cloud Desktop Setup

## Running Storybook

You'll likely need the following command to be able to run storybook:

<https://sage.amazon.com/posts/989642>

```shell
echo fs.inotify.max_user_watches=582222 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```
