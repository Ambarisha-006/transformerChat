
![Set Commerical Pipelines](https://github.com/Smarsh/email-gateway/workflows/Set%20Commerical%20Pipelines/badge.svg)

# Transformer API (tsfa)
A web service that converts batched client content from its captured format into the format expected by the Archive subsystem using various adapters.  Currently, Verizon and SMF adapters are provided and this service is extensible to support many more adapters in the future.

## Table of Contents
- [Documentation](#documentation)
- [Getting Started](#getting-started)
	- [Prerequisites](#prerequisites)
	- [Installing](#installing)
- [Testing](#testing)
	- [Running](#running)
		- [Unit Test Suite](#unit-tests)
		- [Contract Test Suite](#contract-tests)
		- [Mocked Integration Test Suite](#mocked-integration-tests)
		- [Integration Test Suite](#integration-tests)
	- [Contributing](#contributing)

<a name="documentation"/>

## Documentation
See [here](https://smarsh.atlassian.net/wiki/spaces/BEAC/pages/318046243/Transformer+service) for details on the design and architecture of the Transformer API. 

<a name="getting-started"/>

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

<a name="prerequisites"/>

### Prerequisites
TBD

<a name="installing"/>

### Installing
TBD

<a name="testing"/>

## Testing

<a name="running"/>

### Running
See [here](https://smarsh.atlassian.net/wiki/spaces/~206174657/pages/412615053/Component-Level+Test+Organization) for further details on test organization.

<a name="unit-tests"/>

#### Unit Test Suite
`mvn test -P unit-tests`

<a name="contract-tests"/>

#### Contract Test Suite
`mvn test -P contract-tests`

<a name="mocked-integration-tests"/>

#### Mocked Integration Test Suite
`mvn test -P mocked-integration-tests`

<a name="integration-tests"/>

#### Integration Test Suite 
`mvn test -P integration-tests`

<a name="contributing"/>

### Contributing
TBD



