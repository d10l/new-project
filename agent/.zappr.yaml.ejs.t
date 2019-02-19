---
to: .zappr.yaml
---
# this is how you configure zappr
# a more exhaustive description is at
# https://zappr.readthedocs.io/en/latest/setup

# uncomment this if you want to change anything
approvals:
#   by default, an approval is the thumbs up emoji only: ^:\\+1:$
#   uncomment this line to change the approval pattern to "lgtm" at the beginning of the comment
  pattern: "^(:\\+1:|👍)"

#   by default, every pull request requires two approvals
#   uncomment this line to change it to three
  minimum: 1

#   by default, the pull request opener can approve its own pull request
#   uncomment this line to ignore approvals from the pull request opener
#   (there is also `last_committer` and `both`)
#   ignore: pr_opener

#   by default, zappr counts everyone as a valid approver
#   uncomment these lines to change it to only collaborators
#   (you can also specify `orgs` and `users` and define `groups`)
#  from:
#    collaborators: true
autobranch:
  # things in curly brackets are variables that
  # will be replaced. possible variables:
  # - number: the issue number
  # - title: the issue title
  # - labels: the labels of the issue at opening time
  pattern: "{number}-{title}"
  # restrict branch name to maximum this many characters
  length: 60