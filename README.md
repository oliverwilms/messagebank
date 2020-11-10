## messagebank
This is a Message Bank InterSystems IRIS Interoperability solution. It receives Messages and Logs from other InterSystems IRIS Productions so they can be viewed or resent.

## What The Message Bank Does

The Message Bank has an interoperability [production](https://github.com/oliverwilms/messagebank/blob/master/src/MessageBank/Production.cls) with 
You can alter both the URL and frequency in the service's settings.
<img width="1411" alt="Screenshot 2020-10-29 at 19 33 14" src="https://user-images.githubusercontent.com/2781759/97603605-a6d0af00-1a1d-11eb-99cc-481efadb0ec6.png">

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation: ZPM

Create if necessary and open Terminal (IRIS session) in IRIS Namespace with Interoperability enabled:
MESSAGEBANK>zpm "install messagebank"

## Installation: Docker
Clone/git pull the repo into any local directory

```
$ git clone https://github.com/oliverwilms/messagebank.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```



## How to Run the Sample

Open the [production](http://localhost:52795/csp/irisapp/EnsPortal.ProductionConfig.zen?PRODUCTION=dc.Demo.Production) and start it.
It will start gathering news from reddit.com/new/ and filter it on cats and dogs into /output/Dog.txt or /output/Cat.txt files.

You can alter the [business rule](http://localhost:52795/csp/irisapp/EnsPortal.RuleEditor.zen?RULE=dc.Demo.FilterPostsRoutingRule) to filter for different words, or to use an email operation to send posts via email.
<img width="1123" alt="Screenshot 2020-10-29 at 20 05 34" src="https://user-images.githubusercontent.com/2781759/97607761-77707100-1a22-11eb-9ce8-0d14d6f6e315.png">

## How to alter the template 
Use the green    "Use this template" button on Github to copy files into a new repository and build a new IRIS interoperability solution using this one as an example.

This repository is ready to code in VSCode with ObjectScript plugin.
Install [VSCode](https://code.visualstudio.com/), [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) and [ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) plugin and open the folder in VSCode.

Use handy VSCode menu to access production and business rule editor and run a terminal:
<img width="656" alt="Screenshot 2020-10-29 at 20 15 56" src="https://user-images.githubusercontent.com/2781759/97608650-aa673480-1a23-11eb-999e-61e889304e59.png">
