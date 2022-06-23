# Airport DATAWAREHOUSE

This GitHub repository contains an airport datawarehouse.

## Installation

![Docker](https://jolicode.com/media/original/2013/10/homepage-docker-logo.png)

* Browse to this website : <https://docs.docker.com/get-docker/> and follow the instructions for Docker installation.

<img src="https://www.jeveuxetredatascientist.fr/wp-content/uploads/2021/04/power-bi-logo.jpg " width="40%" height="40%" />

* Open Microsoft Store then write down in the search bar `power bi`. Click on install and there you go ! <img src="https://cdn.pixabay.com/photo/2019/02/19/19/45/thumbs-up-4007573_1280.png" width="3%" height="3%" />


## Usage

In the project directory, run the following command :
```
docker-compose up
```

Then, Open the file `Reports.pbix`

## Project Structure

* The `docker-compose.yaml` file will run an image of MySQL, then initilize the database from the init file placed in the mysql folder
* The `Reports.pbix` file contains the Power BI Views.
* The folder mysql/Source Files contains util data about `Airports` `Countries` `Regions` in the format of .csv

## Contributers

* LEKTATI MAHDI
* MONZEIN LEO
* MOKHTARI AHMED
* BADECH MOHAMMED AMINE


