# Concourse: the continuous thing-doer.

Concourse is an automation system written in Go. It is most commonly used for
CI/CD, and is built to scale to any kind of automation pipeline, from simple to
complex.

![pipeline example](https://raw.githubusercontent.com/Concourse/Concourse/master/screenshots/booklit-pipeline.png "pipeline example")

Concourse is very opinionated about a few things: idempotency, immutability,
declarative config, stateless workers, and reproducible builds.

### Learn more about Concourse...

- [Concourse Docs](https://Concourse-ci.org/)
- [Concourse Tutorial](https://Concoursetutorial.com/)
- [Concourse Community Forum](https://discuss.Concourse-ci.org/)
- [Concourse Examples](https://Concourse-ci.org/examples.html)
- [Concourse Cheatsheet](https://cheatsheet.dennyzhang.com/cheatsheet-Concourse-a4)
- [Concourse Build Page Explained](https://medium.com/Concourse-ci/Concourse-build-page-explained-4f92824c98f1)

# Contributing to the ci/ directory
## ci/config
This directory can be used to maintain various configuration-related themes. For example:
- [CF App Manifests](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html)
- [Concourse Pipeline Configuration Files](https://Concourse-ci.org/pipelines.html)
- [Concourse Pipeline Parameter Files](https://Concoursetutorial.com/basics/parameters/)
- [CF App Autoscale Manifests](https://docs.run.pivotal.io/appsman-services/autoscaler/using-autoscaler-cli.html#configure-autoscaling)
```
ci
└──  config
    ├── app-manifests
    │   ├── pcf-environment
    │   │   ├── file.yml
    ├── autoscale-manifests
    │   └── pcf-environment
    │   │   ├── file.yml
    ├── pipeline-parameters
    │   ├── file.yml
    └── pipelines
        └──  file.yml
```

## ci/tasks  
This directory can be used to store [Concourse Task Files](https://Concoursetutorial.com/basics/task-scripts/). An example of the desired structure is as follows:
```
ci
└── tasks
    ├── apply-autoscaler
    │   ├── task.sh
    │   └── task.yml
    ├── blue-green-deployment
    │   ├── task.sh
    │   └── task.yml
    ├── blue-green-deployment-no-interpolation
    │   ├── task.sh
    │   └── task.yml
    ├── interpolate-manifest
    │   ├── task.sh
    │   └── task.yml
    ├── run-build
    │   ├── task.sh
    │   └── task.yml
    └── run-unit-tests
        ├── task.sh
        └── task.yml
```
For every task concept that your pipeline requires, consolidate the logic into [task files](https://Concourse-ci.org/tasks.html) which invoke a subsequent task script. The intention for this is to encapsulate task logic into a more easily maintainable format, as well as to reduce lines in your pipeline configuration.

## Updating Pipeline Configurations (ci/config/pipelines)
Automated actions in your Concourse pipelines are comprised of [Jobs](https://Concourse-ci.org/jobs.html) which can execute get and put [steps](https://Concourse-ci.org/steps.html) against resources defined in your manifest.

#### New Task Scripts
New task actions should be consolidated into scripts which belong in the `ci/tasks` folder according to the pattern depicted above.

The contents of your scripted actions should consider universal [clean code principals](https://x-team.com/blog/principles-clean-code/) 🙏🏼

#### New Pipeline Workflows
Workflows connecting pipeline actions can be configured in two ways:
- **Tasks**: Multiple tasks can be configured within a job. These tasks can share [inputs and outputs](https://Concoursetutorial.com/basics/task-outputs-to-inputs/) in a sequence.

- **Jobs**: A sequence of operations can be created between jobs by prescribing resource dependencies via a get step's [`passed` attribute](https://Concourse-ci.org/get-step.html#get-step-passed).

#### _More on how to contribute to the ci/ directory [Here](CONTRIBUTING.md)_
## Applying Your Pipelines to Concourse

Use the [Concourse Fly CLI](https://Concourse-ci.org/fly.html) to set-pipelines to a target Concourse environment, team, and pipeline.
The pipeline will be also automatically updated right after the changes are deployed to the master branch.
