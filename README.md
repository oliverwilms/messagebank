## messagebank
This is a Message Bank InterSystems IRIS Interoperability solution. It receives Messages and Logs from other InterSystems IRIS Productions so they can be viewed or resent.

## What The Message Bank Does

The Message Bank has an interoperability [production](https://github.com/oliverwilms/messagebank/blob/master/src/MessageBank/Production.cls) with two Services.
<img width="1411" alt="Screenshot of Production" src="https://github.com/oliverwilms/bilder/blob/main/Capture_MessageBank_Production.PNG">

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



## How to Run the Message Bank

docker run --init --detach -p 52773:52773 -p 51773:51773 --name messagebank --volume mbk-vol:/voldata --env ISC_DATA_DIRECTORY=/voldata/iconfig --env ISC_CPF_MERGE_FILE=”/ICS/merge.cpf” --volume /hostinfo:/hostinfo --volume /efs/ICS:/ICS messagebank -b /ICS/vcopy.sh

Open the [production](http://localhost:52795/csp/messagebank/EnsPortal.ProductionConfig.zen?PRODUCTION=MessageBank.Production) and start it if it is not running already.

I use a CPF Merge file to define the ECP Server that I use to store data in mapped globals in a remote database. When the Message Bank Production starts and stops, I update a global with information about the Message Bank, so that containers running IRIS Interoperability production can update the Message Bank Operation to find the Message Bank.


## How to Look for and Resend Messages
Use 

