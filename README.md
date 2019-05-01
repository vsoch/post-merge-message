# Post Merge Message

This is a simple action to post a message to a pull request after merge. As
an example implementation, it posts a message read in from a markdown file 
in a repository to give a user a badge for participation.

## Usage

```
workflow "Post Merge Message" {
  on = "pull_request"
  resolves = ["post message"]
}

action "post message" {
  uses = "vsoch/post-merge-message@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    POST_MESSAGE = "Thanks for your participation!"
  }
}
```

If you want the action to read the message from a file in the repository,
provide it's relative path as the POST_MESSAGE:

```
workflow "Post Merge Message" {
  on = "pull_request"
  resolves = ["post message"]
}

action "post message" {
  uses = "vsoch/post-merge-message@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    POST_MESSAGE = ".circleci/message.txt"
  }
}
```

That's it!
