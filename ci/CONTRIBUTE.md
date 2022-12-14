# How to contribute to this project's CICD configuration

#### **Did you find a bug or misconfiguration?**

* Visit the most relevant Slack channel and validate your finding/concern with the team. Issues regarding the app can be directed to `#connected_capture-dev` in Slack.

* Open a new GitHub pull request.

* Ensure the PR description clearly describes the problem and solution. Include the relevant Jira issue number if applicable.

The repo should have a branch rule configured which requires at least (1) reviewer before a PR can be merged.

#### **Do you intend to add a new ci/config file or category?**

* Refer to the ci/config structure in the [README.md](README.md)
* Open a new GitHub pull request.

* Ensure the PR description clearly describes the problem and solution. Include the relevant Jira issue number if applicable.

#### **Do you intend to add a new ci/task file or category?**

* Refer to the ci/task structure in the [README.md](README.md)
* Open a new GitHub pull request.

* Ensure the PR description clearly describes the problem and solution. Include the relevant Jira issue number if applicable.

#### **How do changes to the ci/ directory get consumed by your pipelines?**
* Changes to ci/ should result in a GitHub Action which automatically authenticates into Concourse and updates your pipelines.

**Note:** _GitHub Actions are underway. For the time being, you must manually engage your pipelines via the Fly CLI._  

#### **Do you have questions about the pipeline conventions and practices exercised in this repo?**

* Visit the most relevant Slack channel for this repo and ask away! - `#connected_capture-dev`
* You're also welcome to participate in `#cicd-knowledge-sharing` when you have general Concourse questions.

Thanks! :heart: :heart: :heart:

Smarsh SaaS Ops Delivery Engineering Team
