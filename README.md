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



## How to Run the Message Bank

Open the [production](http://localhost:52795/csp/messagebank/EnsPortal.ProductionConfig.zen?PRODUCTION=MessageBank.Production) and start it if it is not running already.

## How to Look for and Resend Messages
Use 

